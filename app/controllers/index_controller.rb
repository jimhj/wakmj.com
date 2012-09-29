# coding: utf-8
class IndexController < ApplicationController
  before_filter :check_signed_in, :only => [:sign_up, :sign_in]
  before_filter :require_login, :only => [:sign_out]

  def index
    @tv_dramas = TvDrama.desc('created_at').paginate(:page => params[:page], :per_page => 12)
  end

  def sign_up
  end

  def sign_in
    if request.post?
      user = User.authenticate(params[:email], params[:password])
      if user.present?
        user.update_attribute(:last_signed_in_at, Time.now)
        self.current_user = user
      else
        flash[:error] = '账号或者密码不正确'
      end
      redirect_to :back
    end    
  end

  def sign_out
    clear_login_state
    redirect_to root_path    
  end

  private

  def check_signed_in
    redirect_to :root if signed_in?
    return
  end

end