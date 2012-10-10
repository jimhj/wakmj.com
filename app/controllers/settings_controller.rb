# coding: utf-8

class SettingsController < ApplicationController
  before_filter :require_login

  def account
  end

  def avatar
    if request.post?
      current_user.avatar = params[:avatar]
      unless current_user.save
        flash[:error] = current_user.errors.full_messages
      end
      redirect_to :back
    end
  end

  def password
  end


end