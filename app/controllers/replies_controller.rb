# coding: utf-8

class RepliesController < ApplicationController
  load_and_authorize_resource :reply

  def create
    @topic = Topic.find_by_id params[:topic_id]
    reply = @topic.replies.create!(user_id:current_user.id, tv_drama_id:@topic.tv_drama_id, content:params[:content])
    render :partial => 'reply', :locals => { :reply => reply }, :layout => false
  end

end