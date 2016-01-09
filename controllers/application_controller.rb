class ApplicationController < Sinatra::Base
  helpers ApplicationHelper

  register Sinatra::Flash

  set :bind, '0.0.0.0' # 允许在非本机访问本服务
  set :public_folder, File.expand_path("#{Sinatra::Application.settings.root}/public", __FILE__)
  set :views, File.expand_path("#{Sinatra::Application.settings.root}/views", __FILE__)

  enable :sessions

  # don't enable logging when running tests
  configure :production, :development do
    enable :logging
  end

  configure do
    I18n::Backend::Simple.send(:include, I18n::Backend::Fallbacks)
    I18n.load_path = Dir[File.join(Sinatra::Application.settings.root, 'locales', '*.yml')]
    I18n.backend.load_translations
    I18n.config.available_locales = [:en, :zh]
    I18n.config.default_locale = :zh
  end

  Sequel.sqlite("#{Sinatra::Application.settings.root}/db/book_#{development? ? 'development' : 'production'}.db")
  Dir["#{Sinatra::Application.settings.root}/models/*.rb"].each { |file| require file }
  Sequel::Plugins::ValidationHelpers::DEFAULT_OPTIONS.merge!(
    max_length: { message: lambda { |max| I18n.t('errors.max_length', max: max) }, nil_message: lambda { I18n.t('errors.presence') } },
    min_length: { message: lambda { |min| I18n.t('errors.min_length', min: min) } },
    presence: { message: lambda { I18n.t('errors.presence') } },
    unique: { message: lambda { I18n.t('errors.unique') } }
  )

  not_found do
    status 404
    slim :'404'
  end
end
