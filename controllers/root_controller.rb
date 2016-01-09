class RootController < ApplicationController
  get '/' do
    slim :index
  end

  get '/about' do
    slim :about
  end

  get '/register' do
    slim :register
  end

  get '/login' do
    slim :login
  end

  post '/do_login' do
    @user = User.find(username: params[:username])

    if @user.nil?
      flash[:error] = I18n.t('user.username_not_exist')
      flash[:username] = params[:username]
      redirect '/login'
    else
      if @user.password == Digest::SHA1.hexdigest(params[:password])
        set_login_session(@user)

        redirect '/room'
      else
        flash[:error] = I18n.t('user.password_not_match')
        flash[:username] = params[:username]
        redirect '/login'
      end
    end
  end

  get '/logout' do
    clear_session

    flash[:notice] = I18n.t('user.logout_success')
    redirect '/'
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

  # Notice: 本get始终放在最后
  get '/:book_code' do
    @book = Book.find(code: params[:book_code])

    if @book
      slim :'/books/show'
    else
      slim :'/books/new'
    end
  end
end