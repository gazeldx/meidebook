require 'sinatra'
require 'sinatra/reloader' if development? #NOTICE: For debug, you need uncomment this line and "gem 'sinatra-reloader'" in Gemfile.
require 'sequel'
require 'json'
require 'slim'
require 'active_support/all'

DB = Sequel.sqlite("./db/xinxie_development.db")

set :bind, '0.0.0.0'

enable :sessions

get '/' do
  slim :index
end