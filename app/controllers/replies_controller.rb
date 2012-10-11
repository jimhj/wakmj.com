# coding: utf-8

class RepliesController < ApplicationController
  load_and_authorize_resource :reply

  def create
    @topic = Topic.find_by_id params[:topic_id]
    reply = @topic.replies.create!(user_id:current_user.id, tv_drama_id:@topic.tv_drama_id, content:params[:content])
    @topic.update_attributes(:last_replied_user_id => reply.user_id, :last_replied_at => reply.created_at)
    render :partial => 'reply', :locals => { :reply => reply }, :layout => false
  end

end