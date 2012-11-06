# coding: utf-8
class IndexController < ApplicationController
  before_filter :check_signed_in, :only => [:sign_up, :sign_in, :forgot_password]
  before_filter :require_login, :only => [:sign_out, :confirm]
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
    ids = Redis::Search.query('TvDrama', params[:q], :conditions => { :verify => true }).collect{ |h| h['id'] }
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
      else
        flash[:error] = '账号或者密码不正确'
      end
      redirect_back_or_default(sign_in_path)
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