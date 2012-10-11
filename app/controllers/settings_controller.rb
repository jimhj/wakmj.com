# coding: utf-8

class SettingsController < ApplicationController
  before_filter :require_login

  def account
    if request.post?
      current_user.login = params[:login]
      unless current_user.save
        flash[:error] = current_user.errors.full_messages
      end
      redirect_to :back
    end
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
    if request.post?
      if current_user.password == params[:orig_password]
        current_user.password = params[:password]
        current_user.password_confirmation = params[:password_confirmation]
        if current_user.save
          flash[:success] = '修改密码成功'
        else
          flash[:error] = current_user.errors.full_messages
        end
      else
        flash[:error] = '原密码输入错误'
      end

      redirect_to :back
    end
  end


end