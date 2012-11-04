# coding: utf-8

class MiscsController < ApplicationController

  before_filter :require_login, :only => [:apply_to_edit]

  def show
    @misc = Misc.find_by_slug(params[:id])
  end

  def apply_to_edit
    ApplyToEdit.create!(:user_id => current_user.id, :remarks => params[:remarks])
    render :nothing => true
  end

end