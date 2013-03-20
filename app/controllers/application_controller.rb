# coding: utf-8
class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user, :signed_in?

  def render_404
    render_optional_error_file(404)
  end

  def render_403
    render_optional_error_file(403)
  end

  def render_500
    render_optional_error_file(500)
  end

  def render_optional_error_file(status_code)
    status = status_code.to_s
    if ["404","403", "422", "500"].include?(status)
      render :template => "/errors/#{status}", :format => [:html], :handler => [:haml], :status => status, :layout => "application"
    else
      render :template => "/errors/unknown", :format => [:html], :handler => [:haml], :status => status, :layout => "application"
    end
  end

  if Rails.env.production? 
    rescue_from Exception, :with => :render_500
    rescue_from Mongoid::Errors::DocumentNotFound,    :with => :render_404
    rescue_from ActionController::RoutingError,       :with => :render_404
  end

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = '没有权限进行此项操作，请先注册或者联系管理员'
    redirect_to(:back) rescue redirect_to(:root)
    return
  end


  def signed_in?
    current_user.present?
  end
  
  def require_login
    unless signed_in?
      clear_login_state
      flash[:error] = '请登录后访问'
      redirect_to_login
    end
  end

  def redirect_to_login
    session[:return_to] = request.fullpath
    redirect_to sign_in_path
    return
  end

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
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
    if session[:user_id].blank? && cookies.signed[:remember_me].present?
      session[:user_id] = cookies.signed[:remember_me].split('--')[1]
      self.current_user = User.where(:_id => session[:user_id]).first
    end
  end

  def set_sign_in_cookie
    cookies.signed[:remember_me] = {
      :value => "#{Time.now.to_i}--#{current_user.id}",
      :expires => 1.week.from_now
    }
  end

  def clear_sign_in_cookie
    cookies.delete(:remember_me)
  end

  def clear_login_state
    current_user = nil
    session[:user_id] = nil
    session.clear
  end

  def set_seo_meta(title = nil, meta_keywords = nil, meta_description = nil)
    default_keywords = "美剧，美剧迷，美剧社区，最新美剧，美剧预告，行尸走肉第三季，吸血鬼日记，迷失，生活大爆炸，斯巴达克斯，在线看美剧，美剧下载"
    default_description = %Q(我爱看美剧是一个小型美剧迷社区，专为美剧迷而生，找最新美剧，看剧评，找剧迷就上我爱看美剧)
    @page_title = "#{title}" if title.present?      
    @keywords = meta_keywords || default_keywords
    @description = meta_description || default_description
  end   
end
