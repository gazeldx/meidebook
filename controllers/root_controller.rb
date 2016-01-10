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

  get '/captcha' do
    content_type :png
    session[:captcha] = Captcha.random_text
    Captcha.create(session[:captcha])
  end

  post '/submit_captcha' do
    if params[:captcha].downcase == session[:captcha].downcase
      add_received_books(params[:book_code])
    else
      flash[:error] = I18n.t(:captcha_not_match)
    end

    redirect "/#{params[:book_code]}"
  end

  # Notice: 本get始终放在最后
  get '/:book_code' do
    @book = Book.find(code: params[:book_code])

    if @book
      if session[:received_books].to_s.split(' ').include?(params[:book_code])
        slim :'/books/show'
      else
        slim :'/books/show_captcha'
      end
    else
      slim :'/books/new'
    end
  end
end