# coding: utf-8
class AuthController < ApplicationController
  before_filter :check_signed_in

  def weibo_login
    render_auth_login  
  end

  def renren_login
    render_auth_login('renren')    
  end

  # def new_user
  #   @auth_hash = MultiJson.load(params[:auth] || '{}')
  #   email = params[:email]
  #   if User.where(:email => email).exists?
  #     flash[:error] = 'Email 已经被注册过了'
  #     render :template => 'auth/weibo_login'
  #   else
  #     user = User.create_by_email_and_auth(email, @auth_hash)
  #     if user
  #       user.update_attribute(:last_signed_in_at, Time.now)
  #       self.current_user = user
  #       redirect_to root_path
  #     else
  #       flash[:error] = '注册出错了...'
  #       render :template => 'auth/auth_login'        
  #     end
  #   end    
  # end

  private

  def check_signed_in
    redirect_to :root if signed_in?
    return
  end

  def render_auth_login(auth_type = 'weibo')
    auth = request.env["omniauth.auth"]
    @auth_hash = {
      "#{auth_type}_uid"    =>    auth.uid,
      'name'                =>    auth.info.name,
      'avatar_url'          =>    auth.info.avatar_url,
      "#{auth_type}_token"  =>    auth.credentials.token
    }
    user = User.where(:"#{auth_type}_uid" => auth.uid).first
    if user.blank?
      email = "#{SecureRandom.hex(6)}@#{auth_type}.random.com"
      user = User.create_by_email_and_auth(email, @auth_hash)
      if user
        user.update_attribute(:last_signed_in_at, Time.now)
      else
        flash[:error] = '授权注册出错了...'
      end
    else
      user.update_attribute("#{auth_type}_token".to_sym, auth.credentials.token)
    end
    self.current_user = user 
    redirect_to root_path
  end

end