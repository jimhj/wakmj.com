# coding: utf-8
class DownloadsController < ApplicationController
  layout 'tv_drama'
  before_filter :require_login
  # load_and_authorize_resource

  def new
    @tv_drama = TvDrama.find_by_id(params[:tv_drama_id])
  end

  def create
    @tv_drama = TvDrama.find_by_id(params[:tv_drama_id])
    params[:download][:season] = "S" << params[:download][:season]
    params[:download][:episode] = "E" << params[:download][:episode]
    download = @tv_drama.download_resources.build(params[:download])
    if download.save
      flash[:success] = "新增资源成功" 
    else
      flash[:error] = download.errors.full_messages
    end
    redirect_to :back

  end

end