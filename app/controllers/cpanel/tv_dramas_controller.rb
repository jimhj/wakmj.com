# coding: utf-8
class Cpanel::TvDramasController < Cpanel::ApplicationController

  def index
    @tv_dramas = TvDrama.desc('sort_no').desc('created_at').paginate(:page => params[:page], :per_page => 20)
  end

  def edit
    @tv_drama = TvDrama.where(:_id => params[:id]).first
  end

  def update
    @tv_drama = TvDrama.where(:_id => params[:id]).first
    params[:drama].delete_if { |k, v| k == 'cover' && v.blank? }
    params[:drama][:finished] = (params[:drama][:finished] == "on")
    if @tv_drama.update_attributes(params[:drama])
      flash[:success] = "修改成功"
    else
      flash[:error] = @tv_drama.errors.full_messages
    end
    redirect_to :back    
  end

  def destroy
    @tv_drama = TvDrama.where(:_id => params[:id]).first
    @tv_drama.destroy
    redirect_to :back
  end

  def search
    ids = Redis::Search.query('TvDrama', params[:q], :conditions => { :verify => true }, :limit => 100).collect{ |h| h['id'] }
    @tv_dramas = TvDrama.where(:_id.in => ids).paginate(:page => params[:page], :per_page => 20)    
    render :template => "/cpanel/tv_dramas/index"
  end

  def update_sort
    tv_drama = TvDrama.find_by_id(params[:id])
    tv_drama.sort_no = params[:sort_no].to_i
    # expire_fragment('index_tvs')
    render :text => { :success => tv_drama.save }.to_json
  end

end