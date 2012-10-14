# coding: utf-8

class TopicsController < ApplicationController
  layout 'tv_drama'
  before_filter :require_login, :except => [:show]
  load_and_authorize_resource :except => [:show]
  before_filter :init_topic, :only => [:show, :edit, :update]


  def show
    @tv_drama = @topic.tv_drama
    @replies = @topic.replies.asc('created_at')
    set_seo_meta(@topic.title, nil, @topic.content.truncate(100))
  end

  def new
    @tv_drama = TvDrama.find_by(:_id => params[:tv_drama_id])
    set_seo_meta("新建帖子")
  end

  def create
    topic = current_user.topics.build(
      :tv_drama_id => params[:tv_drama_id],
      :title => params[:title],
      :content => params[:content]
    )

    if topic.save
      topic.tv_drama.update_attribute(:last_topic_id, topic.id)
      redirect_to topic_path(topic)
    else
      flash[:error] = topic.errors.full_messages
      redirect_to :back
    end

  end

  def edit
    @tv_drama = @topic.tv_drama
    set_seo_meta("编辑")
  end

  def update
    @topic.title = params[:title]
    @topic.content = params[:content]
    if @topic.save
      redirect_to topic_path(@topic)
    else
      flash[:error] = @topic.errors.full_messages
      redirect_to :back
    end
  end

  private

  def init_topic
    @topic = Topic.find_by(:_id => params[:id])
  end


end