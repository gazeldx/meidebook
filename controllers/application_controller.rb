class ApplicationController < Sinatra::Base
  helpers ApplicationHelper

  register Sinatra::Flash

  set :bind, '0.0.0.0' # 允许在非本机访问本服务
  set :root, Sinatra::Application.settings.root
  set :public_folder, File.expand_path("#{root}/public", __FILE__)
  set :views, File.expand_path("#{root}/views", __FILE__)

  enable :sessions

  configure(:production, :development) { enable :logging } # don't enable logging when running tests

  configure do
    I18n::Backend::Simple.send(:include, I18n::Backend::Fallbacks)
    I18n.load_path = Dir[File.join(root, 'locales', '*.yml')]
    I18n.backend.load_translations
    I18n.config.available_locales = [:en, :zh]
    I18n.config.default_locale = :zh
  end

  Sequel.sqlite("#{root}/db/book_#{development? ? 'development' : 'production'}.db")
  Dir["#{root}/models/*.rb"].each { |file| require file }
  Sequel::Plugins::ValidationHelpers::DEFAULT_OPTIONS.merge!(
    max_length: { message: lambda { |max| I18n.t('errors.max_length', max: max) }, nil_message: lambda { I18n.t('errors.presence') } },
    min_length: { message: lambda { |min| I18n.t('errors.min_length', min: min) } },
    presence: { message: lambda { I18n.t('errors.presence') } },
    unique: { message: lambda { I18n.t('errors.unique') } }
  )

  # ==== Use Sprockets for asset pipline like rails start ====
  set :assets, Sprockets::Environment.new(root)
  set :assets_prefix, 'assets'
  set :assets_path, File.join(root, 'public', assets_prefix)
  set :sprockets, (Sprockets::Environment.new(root) { |env| env.logger = Logger.new(STDOUT) })

  configure do
    assets.append_path File.join(root, 'assets', 'stylesheets')
    assets.append_path File.join(root, 'assets', 'javascripts')
    sprockets.append_path File.join(root, 'assets', 'stylesheets')
    sprockets.append_path File.join(root, 'assets', 'javascripts')

    Sprockets::Helpers.configure do |config|
      config.environment = assets
      config.prefix      = '/assets'
      config.digest      = true
    end
  end

  helpers do
    include Sprockets::Helpers
  end
  # ==== Use Sprockets for asset pipline like rails end ====

  not_found do
    status 404
    slim :'404'
  end
end
