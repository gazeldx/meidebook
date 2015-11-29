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
  slim :index
end

get '/register' do
  slim :register
end

post '/user/create' do
  User.create(username: params[:username],
              password: Digest::SHA1.hexdigest(params[:password]),
              password_hint: params[:password_hint])

  @data_url = '/room'
  slim :room
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
      set_login_session

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
    flash[:notice] = I18n.t('user.not_login_yet') # TODO: 显示这个提示
    redirect '/login'
  else
    @data_url = '/room'
    slim :room
  end
end

get '/logout' do
  clear_session

  flash[:notice] = I18n.t('user.logout_success') # TODO: 显示这个提示
  redirect '/'
end

helpers do
  def set_login_session
    session[:id] = @user.id
    session[:username] = @user.username
    session[:nickname] = @user.nickname || I18n.t('user.default_nickname')
    session[:email] = @user.email
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
end

