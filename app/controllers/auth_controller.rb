# coding: utf-8
class AuthController < ApplicationController
  before_filter :check_signed_in

  def weibo_login
    auth = request.env["omniauth.auth"]
    @auth_hash = {
      'uid'          =>    auth.uid,
      'name'         =>    auth.info.name,
      'avatar_url'   =>    auth.info.avatar_url,
      'weibo_token'  =>    auth.credentials.token
    }
    user = User.where(:weibo_uid => @auth_hash['uid']).first
    if user.present?
      user.update_attribute(:weibo_token, @auth_hash['weibo_token'])
      self.current_user = user
      redirect_to root_path
    end  
  end

  def new_user
    @auth_hash = MultiJson.load(params[:auth] || '{}')
    email = params[:email]
    if User.where(:email => email).exists?
      flash[:error] = 'Email 已经被注册过了'
      render :template => 'auth/weibo_login'
    else
      user = User.create_by_email_and_auth(email, @auth_hash)
      if user
        user.update_attribute(:last_signed_in_at, Time.now)
        self.current_user = user
        redirect_to root_path
      else
        flash[:error] = '注册出错了...'
        render :template => 'auth/weibo_login'        
      end
    end    
  end

  private

  def check_signed_in
    redirect_to :root if signed_in?
    return
  end

end