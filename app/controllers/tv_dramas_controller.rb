# coding: utf-8

class TvDramasController < ApplicationController
  layout 'tv_drama'

  def show
    @tv_drama = TvDrama.find_by_id(params[:id])
  end

end