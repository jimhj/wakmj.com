# coding: utf-8
class Cpanel::UsersController < Cpanel::ApplicationController

  def index
    @users = params[:order_by].blank? ? User.desc('created_at') : User.desc(params[:order_by])
    @users = @users.paginate(:page => params[:page], :per_page => 20)
  end

end