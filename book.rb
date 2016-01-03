require 'sinatra'
require 'sinatra/reloader' if development? # 用于在测试环境时,不必重启就可以看到代码改动的结果
require 'sinatra/flash'
require 'i18n'
require 'i18n/backend/fallbacks'
require 'sequel'
require 'json'
require 'slim'
require 'active_support/all'
require 'carrierwave'
require 'carrierwave/sequel'

configure do
  I18n::Backend::Simple.send(:include, I18n::Backend::Fallbacks)
  I18n.load_path = Dir[File.join(settings.root, 'locales', '*.yml')]
  I18n.backend.load_translations
  I18n.config.available_locales = [:en, :zh]
  I18n.config.default_locale = :zh
end

# Dir['./controllers/*.rb'].each { |file| require file }
# Dir['./helpers/*.rb'].each { |file| require file }
Dir['./uploaders/*.rb'].each { |file| require file }

Sequel.sqlite("./db/book_#{development? ? 'development' : 'production'}.db")
Dir['./models/*.rb'].each { |file| require file }
Sequel::Plugins::ValidationHelpers::DEFAULT_OPTIONS.merge!(
  max_length: { message: lambda { |max| I18n.t('errors.max_length', max: max) }, nil_message: lambda { I18n.t('errors.presence') } },
  min_length: { message: lambda { |min| I18n.t('errors.min_length', min: min) } },
  presence: { message: lambda { I18n.t('errors.presence') } },
  unique: { message: lambda { I18n.t('errors.unique') } }
)

set :bind, '0.0.0.0' # 允许在非本机访问本服务
# set :port, 4567 # 4567是默认端口,你可以改掉它

enable :sessions

# use LoginController

post '/user/create' do
  user = User.new(username: params[:username],
                  password: Digest::SHA1.hexdigest(params[:password]),
                  password_hint: params[:password_hint])

  if user.valid?
    user.save

    set_login_session(user)

    redirect '/room'
  else
    flash[:username] = params[:username]
    flash[:password_hint] = params[:password_hint]
    flash_errors(user)
    redirect '/register'
  end
end

get '/room' do
  if session[:user_id].blank?
    flash[:notice] = I18n.t('user.not_login_yet')
    redirect '/login'
  else
    @posts = Post.where(user_id: session[:user_id]).reverse_order(:id)
    slim :room
  end
end

post '/book/create' do
  book = Book.new(code: params[:book_code],
                  created_at: Time.now,
                  updated_at: Time.now)

  if book.valid?
    book.save

    comment = Comment.new(book_id: book.id,
                          photo: params[:photo],
                          created_at: Time.now,
                          updated_at: Time.now)
    comment.save

    redirect "/#{params[:book_code]}"
  else
    flash[:body] = params[:body]
    flash_errors(book)
    redirect "/#{params[:book_code]}"
  end
end

# Notice: 本get始终放在最后
get '/:book_code' do
  @book = Book.find(code: params[:book_code])

  if @book
    slim :'/books/show'
  else
    slim :'/books/new'
  end
end

not_found do
  status 404
  slim :'404'
end

