# coding: utf-8

class MiscsController < ApplicationController

  def show
    @misc = Misc.find_by_slug(params[:id])
  end
end