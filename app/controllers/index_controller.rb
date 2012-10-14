# coding: utf-8
class IndexController < ApplicationController
  before_filter :check_signed_in, :only => [:sign_up, :sign_in]
  before_filter :require_login, :only => [:sign_out]

  def index
    @tv_dramas = TvDrama.asc('created_at')
    if params[:cate]
      @tv_dramas = @tv_dramas.where(:categories => params[:cate])
    end

    if params[:year]
      begin_of_year = (params[:year] + '0101').to_datetime.at_beginning_of_year
      end_of_year = begin_of_year.at_end_of_year
      @tv_dramas = @tv_dramas.between(:release_date => begin_of_year..end_of_year)
    end

    @tv_dramas = @tv_dramas.includes(:topics).paginate(:page => params[:page], :per_page => 12)
    set_seo_meta
  end

  def recents
    @tv_dramas = TvDrama.recents.paginate(:page => params[:page], :per_page => 12)
    set_seo_meta('新剧')
    render :action => :index
  end

  def hots
    @tv_dramas = TvDrama.hots.paginate(:page => params[:page], :per_page => 12)
    set_seo_meta('热门')
    render :action => :index
  end

  def sign_up
    if request.post?
      user = User.new(params[:user])
      if user.valid?
        if params[:user][:password].length < 6
          flash[:error] = "密码不能少于6位"
          redirect_to :back
        else
          user.save && User.perform_async(:send_sign_up_mail, user._id)
          self.current_user = user
          user.update_attribute(:last_signed_in_at, Time.now)
          redirect_to :root
        end
      else
        flash[:error] = user.errors.full_messages
        redirect_to :back
      end
    end
    set_seo_meta('注册')
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
      redirect_back_or_default(root_path)
    end
    set_seo_meta('登录')    
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