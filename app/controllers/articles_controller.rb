# coding: utf-8

class ArticlesController < ApplicationController
  layout 'tv_drama'

  def index
  end

  def show
    @article = Article.find_by_id(params[:id])
    @tv_drama = @article.tv_drama
  end


end