class UsersController < ApplicationController
  get '/' do
    if admin?
      @users = User.all
      slim :'/users/index'
    end
  end

  post '/' do
    user = User.new(username: params[:username],
                    domain: User.default_domain,
                    password: Digest::SHA1.hexdigest(params[:password]),
                    password_hint: params[:password_hint],
                    created_at: Time.now,
                    updated_at: Time.now)

    if user.valid?
      user.save
      set_login_session(user)
      flash[:notice] = I18n.t('user.register_finished')
      redirect '/settings'
    else
      flash[:username] = params[:username]
      flash[:password_hint] = params[:password_hint]
      flash_errors(user)
      redirect '/register'
    end
  end

  post '/do_settings' do
    current_user.set(domain: params[:domain], nickname: params[:nickname], updated_at: Time.now)
    if current_user.valid?
      current_user.save
      flash[:notice] = "设置已更新。"
    else
      flash_errors(current_user)
    end

    redirect '/settings'
  end
end