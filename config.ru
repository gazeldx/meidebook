require './book'
#
# run Sinatra::Application

require 'sinatra/base'

# pull in the helpers and controllers
# Dir.glob('./{helpers,controllers}/*.rb').each { |file| require file }
# Dir.glob("#{Sinatra::Application.settings.root}/{helpers,controllers}/*.rb").each { |file| require file }
require './helpers/application_helper'
require './controllers/application_controller'
require './controllers/login_controller'
require './controllers/posts_controller'
# map the controllers to routes
# map('/example') { run ExampleController }
map('/') { run LoginController }
map('/posts') { run PostsController }
