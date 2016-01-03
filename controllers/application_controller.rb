# require 'sinatra/flash'

class ApplicationController < Sinatra::Base
  helpers ApplicationHelper

  register Sinatra::Flash

  # set :root, File.dirname(__FILE__)
  set :public_folder, File.expand_path('../../public', __FILE__)
  set :views, File.expand_path('../../views', __FILE__)

  enable :sessions

  # don't enable logging when running tests
  configure :production, :development do
    enable :logging
  end
end
