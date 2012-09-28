# coding: utf-8

class TopicsController < ApplicationController
  layout 'tv_drama'

  def show
  end

  def new
    @tv_drama = TvDrama.find_by_id(params[:tv_drama_id])
  end

end