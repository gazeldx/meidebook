module ApplicationHelper
  def include_slim(name, options = {}, &block)
    Slim::Template.new("#{name}.slim", options).render(self, &block)
  end

  def include_erb(name, options = {}, &block)
    Slim::Template.new("#{name}.erb", options).render(self, &block)
  end

  def current_user
    User.find(session[:user_id]) if session[:user_id].present?
  end

  def logged?
    session[:user_id].present?
  end

  def set_login_session(user)
    session[:user_id] = user.id
    session[:username] = user.username
    session[:nickname] = user.nickname || I18n.t('user.default_nickname')
    session[:email] = user.email
  end

  def clear_session
    session[:user_id], session[:username], session[:nickname], session[:email] = nil, nil, nil, nil
  end

  def notice_info
    # require 'sinatra/flash'
    result = ''
    if flash[:notice]
      result = "<div class='weui_toptips weui_primary js_tooltips' style='display:block!important;'>#{flash[:notice]}</div>"
      flash[:notice] = nil
    end
    result
  end

  def error_info
    result = ''
    if flash[:error]
      result = "<div class='weui_toptips weui_warn js_tooltips' style='display:block!important;'>#{flash[:error]}</div>"
      flash[:error] = nil
    end
    result
  end

  def errors_message
    if flash[:errors].present?
      full_msg = ''
      flash[:errors].except(:model_name).each do |column, error_messages|
        error_messages.each do |error_message|
          full_msg = full_msg + '<li>' + I18n.t("#{flash[:errors][:model_name]}.#{column.to_s}") + ' ' + error_message + '</li>'
        end
      end
      "<div id='error_explanation' style='color: red' role='alert'><ul>#{full_msg}</ul></div>"
    end
  end

  def flash_errors(model)
    flash[:errors] = model.errors.merge(model_name: model.class.to_s.downcase)
  end

  def logout_button
    "<a href='/logout' class='weui_btn weui_btn_plain_default'>#{I18n.t('user.logout')}</a>" if session[:user_id]
  end
end