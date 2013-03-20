# coding: utf-8
class DownloadsController < ApplicationController
  layout 'tv_drama'
  before_filter :require_login
  before_filter :init_tv_drama, :only => [:show, :lixian, :play]
  # load_and_authorize_resource DownloadResource

  def new
    @tv_drama = TvDrama.find_by_id(params[:tv_drama_id])
  end

  def create
    @tv_drama = TvDrama.find_by_id(params[:tv_drama_id])
    params[:download][:season] = params[:download][:season]
    params[:download][:episode] = params[:download][:episode]
    download = @tv_drama.download_resources.build(params[:download])
    if download.save
      flash[:success] = "新增资源成功" 
    else
      flash[:error] = download.errors.full_messages
    end
    redirect_to :back
  end

  def show
    redirect_to @download.download_link
  end

  def lixian
    redirect_to (Setting.xunlei_url + @download.download_link)
  end

  def play    
    render :layout => 'play'
  end

  private

  def init_tv_drama
    @tv_drama = TvDrama.find_by_id(params[:tv_drama_id])
    @download = @tv_drama.download_resources.where(:_id => params[:id]).first
  end

end