class UsersController < ApplicationController
  post '/' do
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
end