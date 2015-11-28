require 'sinatra'
require 'sinatra/reloader' if development? #NOTICE: For debug, you need uncomment this line and "gem 'sinatra-reloader'" in Gemfile.
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
    redirect '/login'
  else
    if @user.password == Digest::SHA1.hexdigest(params[:password])
      @data_url = '/room'
      slim :room
    else
      flash[:error] = I18n.t('user.password_not_match')
      redirect '/login'
    end
  end
end

