# coding: utf-8
class Cpanel::UsersController < Cpanel::ApplicationController

  def index
    @users = User.desc('created_at').paginate(:page => params[:page], :per_page => 20)
  end

end