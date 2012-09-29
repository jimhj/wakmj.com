# coding: utf-8
class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user, :signed_in?

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = '没有权限进行此项操作，请联系管理员'
    redirect_to :back
    return
  end


  def signed_in?
    current_user.present?
  end
  
  def require_login
    unless signed_in?
      clear_login_state
      flash[:error] = '请登录后访问'
      redirect_to root_path
      return
    end
  end

  def current_user    
    @current_user ||= begin
      login_from_session || login_from_cookie
    end

    # @current_user ||= begin
    #   User.current = (login_from_session || login_from_cookie)  
    # end
  end

  # Store the given user id in the session.
  def current_user=(new_user)
    session[:user_id] = new_user ? new_user.id : nil
    @current_user = new_user || nil
  end

  def login_from_session
    self.current_user = User.where(:_id => session[:user_id]).first if session[:user_id]
  end

  def login_from_cookie
    nil
  end

  def clear_login_state
    current_user = nil
    session[:user_id] = nil
    session.clear
  end
end
