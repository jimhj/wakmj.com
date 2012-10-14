# coding: utf-8

class ArticlesController < ApplicationController
  layout 'tv_drama'

  def index
  end

  def show
    @article = Article.find_by(:_id => params[:id])
    @tv_drama = @article.tv_drama
    set_seo_meta(@article.title, nil, @article.summary)
  end


end