module ApplicationHelper
  def include_slim(name, options = {}, &block)
    Slim::Template.new("#{Sinatra::Application.settings.root}/views/#{name}.slim", options).render(self, &block)
  end

  def include_erb(name, options = {}, &block)
    Slim::Template.new("#{Sinatra::Application.settings.root}/views/#{name}.erb", options).render(self, &block)
  end

  def current_user
    @_user = User[session[:user_id]] if @_user.nil?
    @_user
  end

  def logged?
    current_user.present?
  end

  def admin?
    logged? && current_user.id == 1
  end

  def min_if_production
    Sinatra::Base.production? ? 'min.' : ''
  end

  def set_login_session(user)
    session[:user_id] = user.id
  end

  def clear_session
    session[:user_id] = nil
  end

  def add_received_books(book_code)
    session[:received_books] = session[:received_books].to_s << "#{book_code} "
  end

  def notice_info
    result = ''
    if flash[:notice]
      result = "<div class='weui_toptips weui_primary js_tooltips' style='color: red; display:block!important;'>#{flash[:notice]}</div>"
      flash[:notice] = nil
    end
    result
  end

  def error_info
    result = ''
    if flash[:error]
      result = "<div class='weui_toptips weui_warn js_tooltips' style='color: white; display:block!important;'>#{flash[:error]}</div>"
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
    "<a href='/logout' class='weui_btn weui_btn_mini weui_btn_default'>#{I18n.t('user.logout')}</a>" if logged?
  end
end