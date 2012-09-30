# coding: utf-8

class TopicsController < ApplicationController
  layout 'tv_drama'

  load_and_authorize_resource :except => [:show]

  def show
    @topic = Topic.find_by_id params[:id]
    @tv_drama = @topic.tv_drama
    @replies = @topic.replies.desc('created_at')
  end

  def new
    @tv_drama = TvDrama.find_by_id(params[:tv_drama_id])
  end

  def create
    topic = current_user.topics.build(
      :tv_drama_id => params[:tv_drama_id],
      :title => params[:title],
      :content => params[:content]
    )

    if topic.save
      redirect_to topic_path(topic)
    else
      flash[:error] = topic.errors.full_messages
      redirect_to :back
    end

  end


end