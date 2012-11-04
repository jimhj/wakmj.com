# coding: utf-8
class Cpanel::AppliesController < Cpanel::ApplicationController
  
  def index
    @applies = ApplyToEdit.desc('created_at').paginate(:page => params[:page], :per_page => 20)
  end

  def pass
    aply = ApplyToEdit.find_by_id(params[:id])
    render :text => { :success => aply.pass }.to_json
  end

end
