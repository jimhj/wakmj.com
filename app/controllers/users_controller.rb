# coding: utf-8

class UsersController < ApplicationController
  
  def show
    @user = User.find_by_id params[:id]
    @topics = @user.topics.includes(:tv_drama).desc('created_at')
  end

  def create
    user = User.new(params[:user])
    if user.save
      self.current_user = user
      user.update_attribute(:last_signed_in_at, Time.now)
      redirect_to :root
    else
      flash[:error] = user.errors.full_messages
      redirect_to :back
    end
  end

end