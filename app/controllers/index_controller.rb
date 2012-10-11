# coding: utf-8
class IndexController < ApplicationController
  before_filter :check_signed_in, :only => [:sign_up, :sign_in]
  before_filter :require_login, :only => [:sign_out]

  def index
    @tv_dramas = TvDrama.desc('created_at')
    if params[:cate]
      @tv_dramas = @tv_dramas.where(:categories => params[:cate])
    end

    if params[:year]
      begin_of_year = (params[:year] + '0101').to_datetime.at_beginning_of_year
      end_of_year = begin_of_year.at_end_of_year
      @tv_dramas = @tv_dramas.between(:release_date => begin_of_year..end_of_year)
    end

    @tv_dramas = @tv_dramas.includes(:topics).paginate(:page => params[:page], :per_page => 12)

  end

  def recents
    b_time = '20120101'.to_datetime.at_beginning_of_year
    e_time = b_time.at_end_of_year
    @tv_dramas = TvDrama.between(:release_date => b_time..e_time).paginate(:page => params[:page], :per_page => 12)
    render :action => :index
  end

  def hots
    @tv_dramas = TvDrama.hots.paginate(:page => params[:page], :per_page => 12)
    render :action => :index
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