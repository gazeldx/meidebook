require 'sinatra'
require 'sinatra/reloader' if development? # 用于在测试环境时,不必重启就可以看到代码改动的结果
require 'sinatra/flash'
require 'i18n'
require 'i18n/backend/fallbacks'
require 'sequel'
require 'json'
require 'slim'
require 'active_support/all'

configure do
  I18n::Backend::Simple.send(:include, I18n::Backend::Fallbacks)
  I18n.load_path = Dir[File.join(settings.root, 'locales', '*.yml')]
  I18n.backend.load_translations
  I18n.config.available_locales = [:en, :zh]
  I18n.config.default_locale = :zh
end

Sequel.sqlite("./db/xinxue_#{development? ? 'development' : 'production'}.db")
Dir['./models/*.rb'].each { |file| require file }
Sequel::Plugins::ValidationHelpers::DEFAULT_OPTIONS.merge!(
  max_length: { message: lambda { |max| I18n.t('errors.max_length', max: max) }, nil_message: lambda { I18n.t('errors.presence') } },
  min_length: { message: lambda { |min| I18n.t('errors.min_length', min: min) } },
  presence: { message: lambda { I18n.t('errors.presence') } }
)

set :bind, '0.0.0.0' # 允许在非本机访问本服务
# set :port, 4567 # 4567是默认端口,你可以改掉它

enable :sessions

get '/' do
  @data_url = '/'
  slim :index
end

get '/register' do
  @data_url = '/register'
  slim :register
end

post '/user/create' do
  user = User.new(username: params[:username],
                  password: Digest::SHA1.hexdigest(params[:password]),
                  password_hint: params[:password_hint])

  if user.valid?
    user.save

    set_login_session(user)

    redirect '/room'
  else
    flash[:username] = params[:username]
    flash[:password_hint] = params[:password_hint]
    flash_errors(user)
    redirect '/register'
  end
end

get '/login' do
  @data_url = '/login'
  slim :login
end

post '/do_login' do
  @user = User.find(username: params[:username])

  if @user.nil?
    flash[:error] = I18n.t('user.username_not_exist')
    flash[:username] = params[:username]
    redirect '/login'
  else
    if @user.password == Digest::SHA1.hexdigest(params[:password])
      set_login_session(@user)

      redirect '/room'
    else
      flash[:error] = I18n.t('user.password_not_match')
      flash[:username] = params[:username]
      redirect '/login'
    end
  end
end

get '/room' do
  if session[:user_id].blank?
    flash[:notice] = I18n.t('user.not_login_yet')
    redirect '/login'
  else
    @data_url = '/room'
    slim :room
  end
end

get '/logout' do
  clear_session

  flash[:notice] = I18n.t('user.logout_success')
  redirect '/'
end

get '/posts/new' do
  @data_url = '/posts/new'
  slim '/posts/new'.to_sym
end

get '/posts' do
  @posts = Post.where(user_id: session[:user_id])
  @data_url = '/posts'
  slim :'posts/index'
end

post '/post/create' do
  post = Post.new(title: params[:title],
                  body: params[:body],
                  user_id: session[:user_id],
                  created_at: Time.now,
                  updated_at: Time.now)

  if post.valid?
    post.save
    redirect '/posts'
  else
    flash[:title] = params[:title]
    flash[:body] = params[:body]
    flash_errors(post)
    redirect '/posts/new'
  end
end

helpers do
  def include_slim(name, options = {}, &block)
    Slim::Template.new("#{name}.slim", options).render(self, &block)
  end

  def current_user
    User.find(session[:user_id]) if session[:user_id].present?
  end

  def logged?
    session[:user_id].present?
  end

  def set_login_session(user)
    session[:user_id] = user.id
    session[:username] = user.username
    session[:nickname] = user.nickname || I18n.t('user.default_nickname')
    session[:email] = user.email
  end

  def clear_session
    session[:user_id], session[:username], session[:nickname], session[:email] = nil, nil, nil, nil
  end

  def notice_info
    result = ''
    if flash[:notice]
      result = "<p style='color: green'>#{flash[:notice]}</p>"
      flash[:notice] = nil
    end
    result
  end

  def error_info
    result = ''
    if flash[:error]
      result = "<p style='color: red'>#{flash[:error]}</p>"
      flash[:error] = nil
    end
    result
  end

  def errors_message
    if flash[:errors].present?
      full_msg = ''
      flash[:errors].except(:model_name).each do |column, error_messages|
        error_messages.each do |error_message|
          full_msg = full_msg + '<li>' + I18n.t("#{flash[:errors][:model_name]}.#{column.to_s}") + ' ' + error_message + '</li>'
        end
      end
      "<div id='error_explanation' style='color: red' role='alert'><ul>#{full_msg}</ul></div>"
    end
  end

  def flash_errors(model)
    flash[:errors] = model.errors.merge(model_name: model.class.to_s.downcase)
  end
end

