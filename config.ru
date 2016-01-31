require 'sinatra'
require 'sinatra/base'
require 'sinatra/flash'
require 'sprockets'
require 'sprockets-helpers'
require 'sinatra/reloader' if development? # 用于在测试环境时,不必重启就可以看到代码改动的结果
require 'sequel'
require 'slim'
require 'carrierwave'
require 'carrierwave/sequel'
require 'active_support/all'
require 'json'
require 'i18n'
require 'i18n/backend/fallbacks'

Dir.glob("#{Sinatra::Application.settings.root}/{lib,helpers,uploaders}/*.rb").each { |file| require file }
Dir.glob("#{Sinatra::Application.settings.root}/{controllers}/*.rb").sort.each { |file| require file }

map('/assets') { run ApplicationController.sprockets }
map('/') { run RootController }
map('/books') { run BooksController }
map('/comments') { run CommentsController }
map('/posts') { run PostsController }
map('/users') { run UsersController }