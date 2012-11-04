# coding: utf-8
class Cpanel::TvDramasController < Cpanel::ApplicationController

  def index
    @tv_dramas = TvDrama.desc('sort_no').desc('created_at').paginate(:page => params[:page], :per_page => 20)
  end

  def search
    ids = Redis::Search.query('TvDrama', params[:q], :conditions => { :verify => true }).collect{ |h| h['id'] }
    @tv_dramas = TvDrama.where(:_id.in => ids).paginate(:page => params[:page], :per_page => 20)    
    render :template => "/cpanel/tv_dramas/index"
  end

  def update_sort
    tv_drama = TvDrama.find_by_id(params[:id])
    tv_drama.sort_no = params[:sort_no].to_i
    expire_fragment('index_tvs')
    render :text => { :success => tv_drama.save }.to_json
  end

end