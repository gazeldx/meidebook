require 'sinatra'
require 'sinatra/reloader' if development? #NOTICE: For debug, you need uncomment this line and "gem 'sinatra-reloader'" in Gemfile.
require 'sequel'
require 'json'
require 'slim'
require 'active_support/all'

Sequel.sqlite("./db/xinxue_#{development? ? 'development' : 'production'}.db")

Dir['./models/*.rb'].each { |file| require file }

set :bind, '0.0.0.0'
set :port, 1982

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
  slim :login
end

post '/do_login' do
  User.find_by_username(params[:username]),
              password: Digest::SHA1.hexdigest(params[:password]),
              password_hint: params[:password_hint])

  slim :room
end

