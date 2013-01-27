# coding: utf-8
class Cpanel::PreReleasesController < Cpanel::ApplicationController

  def index
    @pre_releases = PreRelease.includes(:tv_drama).desc('created_at')

    if params[:tv_drama_id]
      @pre_releases = @pre_releases.where(:tv_drama_id => params[:tv_drama_id])
    end

    @pre_releases = @pre_releases.paginate(:page => params[:page], :per_page => 20)

  end

  def new
    @tv_drama = TvDrama.find(params[:tv_drama_id])
  end

  def create
    @tv_drama = TvDrama.find(params[:pre_release][:tv_drama_id])
    pre = @tv_drama.pre_releases.build(params[:pre_release])
    if pre.save
      flash[:success] = "新增成功"
    else
      flash[:error] = pre.errors.full_messages
    end
    redirect_to :back    
  end

end