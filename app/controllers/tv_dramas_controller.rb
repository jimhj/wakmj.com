# coding: utf-8

class TvDramasController < ApplicationController
  layout 'tv_drama'
  before_filter :require_login, :except => [:show]
  before_filter :init_tv_drama, :except => [:create, :new]

  # load_and_authorize_resource :only => [:edit, :update, :create]
  load_and_authorize_resource

  def show
    @topics = @tv_drama.topics.desc('created_at').includes(:user).paginate(:page => params[:page])
    @resources = @tv_drama.download_resources
    @resources = @resources.where(:season => params[:season]) unless params[:season].blank?
    @resources = @resources.desc('season').paginate(:page => params[:page])
    @seasons = @tv_drama.download_resources.distinct(:season)
    @pre_releases = @tv_drama.pre_releases

    set_seo_meta(@tv_drama.tv_name, @tv_drama.category_list, @tv_drama.summary)

    respond_to do |format|
      format.html
      # Ajax Paginate.
      format.js {
        if params[:to] == 'downloads' 
          html_str = render_to_string(:partial => 'resources')
        elsif params[:to] == 'topics'
          html_str = render_to_string(:partial => 'topics')
        end 
        render :text => html_str.to_json
      }
    end
    
  end

  def edit
  end

  def update
    params[:drama].delete_if { |k, v| k == 'cover' && v.blank? }
    if @tv_drama.update_attributes(params[:drama])
      redirect_to tv_drama_path(@tv_drama)
    else
      flash[:error] = @tv_drama.errors.full_messages
      redirect_to :back
    end
  end

  def create
    tv_drama = TvDrama.new(params[:drama])
    tv_drama.created_by = current_user.id.to_s
    if tv_drama.save
      redirect_to tv_drama_path(tv_drama)
    else
      flash[:error] = tv_drama.errors.full_messages
      redirect_to :back      
    end
  end

  def new
    can_create = begin
      authorize!(:create, TvDrama)
        nil 
      rescue Exception => e
        "没有权限新建剧集，请点击左侧‘帮我们维护按钮’，谢谢"
    end
    
    if can_create.nil?
      @tv_drama = TvDrama.first
      render :layout => 'application'
    else
      flash[:error] = can_create
      redirect_to user_path(current_user.login)
    end
  end

  private

  def init_tv_drama
    @tv_drama = TvDrama.find_by(:_id => params[:id])
  end

end