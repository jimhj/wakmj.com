# coding: utf-8

class LikesController < ApplicationController
  before_filter :require_login, :find_likeable

  def create
    if @likeable.present?
      current_user.like(@likeable)
      render :text => { :success => true, :likes_count => @likeable.reload.likes_count }.to_json
    else
      render :text => { :success => false }.to_json
    end
  end

  def destroy
    if @likeable.present?
      current_user.unlike(@likeable)
      render :text => { :success => true, :likes_count => @likeable.reload.likes_count }.to_json
    else
      render :text => { :success => false }.to_json
    end    
  end

  private

  def find_likeable
    klass = params[:likeable_type].safe_constantize
    @likeable = klass.find_by_id(params[:likeable_id])

  end

end