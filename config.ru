require 'sinatra'
require 'sinatra/base'
require 'sinatra/flash'
require 'sinatra/reloader' if development? # 用于在测试环境时,不必重启就可以看到代码改动的结果
require 'sequel'
require 'slim'
require 'carrierwave'
require 'carrierwave/sequel'
require 'active_support/all'
require 'json'
require 'i18n'
require 'i18n/backend/fallbacks'

Dir.glob("#{Sinatra::Application.settings.root}/{lib,helpers,uploaders,controllers}/*.rb").each do |file|
  puts file.inspect
  require file
end

map('/') { run RootController }
map('/books') { run BooksController }
map('/comments') { run CommentsController }
map('/posts') { run PostsController }
map('/users') { run UsersController }