# coding: utf-8
class Cpanel::IndexController < Cpanel::ApplicationController

  def yesterday
    @users_count = User.yesterday_total_count
    @tv_dramas_count = TvDrama.yesterday_total_count
    @topics_count = Topic.yesterday_total_count
    @replies_count = Reply.yesterday_total_count
    @res_count = DownloadResource.yesterday_total_count
    render :template => 'cpanel/index/statistic'
  end

  def today
    @users_count = User.where(:created_at.gte => Time.now.at_beginning_of_day).count
    @tv_dramas_count = TvDrama.where(:created_at.gte => Time.now.at_beginning_of_day).count
    @topics_count = Topic.where(:created_at.gte => Time.now.at_beginning_of_day).count
    @replies_count = Reply.where(:created_at.gte => Time.now.at_beginning_of_day).count
    @res_count = DownloadResource.where(:created_at.gte => Time.now.at_beginning_of_day).count
    render :template => 'cpanel/index/statistic'
  end
  
end
