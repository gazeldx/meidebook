require 'sinatra'
require 'sinatra/reloader' if development? # 用于在测试环境时,不必重启就可以看到代码改动的结果
require 'sinatra/flash'
require 'i18n'
require 'i18n/backend/fallbacks'
require 'sequel'
require 'json'
require 'slim'
require 'active_support/all'

Sequel.sqlite("./db/xinxue_#{development? ? 'development' : 'production'}.db")
Dir['./models/*.rb'].each { |file| require file }

configure do
  I18n::Backend::Simple.send(:include, I18n::Backend::Fallbacks)
  I18n.load_path = Dir[File.join(settings.root, 'locales', '*.yml')]
  I18n.backend.load_translations
  I18n.config.available_locales = [:en, :zh]
  I18n.config.default_locale = :zh
end

set :bind, '0.0.0.0' # 允许在非本机访问本服务
# set :port, 4567 # 4567是默认端口,你可以改掉它

enable :sessions

get '/' do
  @data_url = '/'
  slim :index
end

get '/register' do
  puts "@user is #{@user.inspect}"
  @data_url = '/register'
  slim :register
end

post '/user/create' do
  @user = User.new(username: params[:username],
                  password: Digest::SHA1.hexdigest(params[:password]),
                  password_hint: params[:password_hint])

  if @user.valid?
    @user.save

    set_login_session(@user)

    redirect '/room'
  else
    flash[:errors] = @user.errors
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
  if session[:id].blank?
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

helpers do
  def set_login_session(user)
    session[:id] = user.id
    session[:username] = user.username
    session[:nickname] = user.nickname || I18n.t('user.default_nickname')
    session[:email] = user.email
  end

  def clear_session
    session[:id], session[:username], session[:nickname], session[:email] = nil, nil, nil, nil
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
      flash[:errors].each do |column, error_messages|
        error_messages.each do |error_message|
          full_msg = full_msg + '<li>' + column.to_s + ' ' + error_message + '</li>'
        end
      end
      "<div id='error_explanation' style='color: red' role='alert'><ul>#{full_msg}</ul></div>"
    end
  end
end

