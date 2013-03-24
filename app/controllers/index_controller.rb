# coding: utf-8
class IndexController < ApplicationController
  before_filter :check_signed_in, :only => [:sign_up, :sign_in, :forgot_password, :confirm, :reset_password]
  before_filter :require_login, :only => [:sign_out]
  before_filter :init_email_token, :only => [:confirm, :reset_password]
  # caches_page :index, :recents, :hots, :expires_in => 1.hours

  def index
    @tv_dramas = TvDrama.desc('sort_no').asc('created_at')
    # @tv_dramas = TvDrama.desc('download_resource.created_at')
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

  def forgot_password
    if request.post?
      if User.where(:email => params[:email]).exists?
        begin
          EmailConfirmToken.perform_async(:send_confirm_link, params[:email]) 
          flash[:success] = "修改密码确认邮件已发往你的邮箱，请查收"
        rescue Exception => e
          flash[:error] = e.inspect
        end
        
      else
        flash[:error] = "输入的邮箱不存在，请重新输入"
      end
      redirect_to :back
    end
  end

  def confirm
    if @confirm_token && @confirm_token.unexpired?
      render 
    else
      flash[:error] = "重置密码链接是无效的或已经过期，请重新发送邮件到注册邮箱"
      render :action => :forgot_password
    end
  end
  
  def reset_password
    return if @confirm_token.nil? || !@confirm_token.unexpired?
    user = User.find_by(:email => params[:email])
    return if user.nil?
    user.password = params[:password]
    user.password_confirmation = params[:password_confirmation]
    if params[:password].length < 6
      flash[:error] = "密码不能少于6位"
      render :action => :confirm      
    else
      if user.save
        @confirm_token.update_attribute(:status, 1)
        flash[:success] = "重置密码成功，请重新登录"
        redirect_to sign_in_path
      else
        flash[:error] = user.errors.full_messages
        render :action => :confirm
      end
    end    
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

  def search
    ids = Redis::Search.query('TvDrama', params[:q], :conditions => { :verify => true }, :limit => 100).collect{ |h| h['id'] }
    @tv_dramas = TvDrama.where(:_id.in => ids).paginate(:page => params[:page], :per_page => 12)
    # @tv_dramas = TvDrama.all.paginate(:page => params[:page], :per_page => 12)
    set_seo_meta('搜索剧集')
  end

  def sign_in
    if request.post?
      user = User.authenticate(params[:email], params[:password])
      if user.present?
        user.update_attribute(:last_signed_in_at, Time.now)
        self.current_user = user
        params[:remember_me].blank? ? clear_sign_in_cookie : set_sign_in_cookie
      else
        flash[:error] = '账号或者密码不正确'
      end
      redirect_back_or_default(sign_in_path)
    end
    set_seo_meta('登录')    
  end

  def sign_out
    clear_login_state
    clear_sign_in_cookie
    redirect_to root_path    
  end

  def timesheet
    @pre_releases = PreRelease.all.collect do |p| 
      { 
        :title => "#{p.tv_drama_tv_name} S#{p.season}E#{p.episode}", 
        :start => p.release_date.at_beginning_of_day,
        :end => p.release_date.end_of_day,
        :url => tv_drama_path(p.tv_drama) 
      }
    end.to_json
  end

  private

  def check_signed_in
    redirect_to :root if signed_in?
    return
  end

  def init_email_token
    @confirm_token = EmailConfirmToken.where(:email => params[:email], :token => params[:token]).first
  end

end