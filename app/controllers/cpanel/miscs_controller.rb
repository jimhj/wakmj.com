# coding: utf-8
class Cpanel::MiscsController < Cpanel::ApplicationController

  def index
    @miscs = Misc.all
  end

  def new
  end

  def create
    misc = Misc.new(params[:misc])
    if misc.save
      flash[:success] = "创建单页成功"
    else
      flash[:error] = misc.errors.full_messages
    end
    redirect_to :back
  end

  def edit
    @misc = Misc.find_by_id(params[:id])
  end

  def update
    misc = Misc.find_by_id(params[:id])
    # misc.title = params[:misc][:title]
    # misc.slug = params[:misc][:slug]
    # misc.content = params[:misc][:content]
    # misc.category = params[:misc][:category]
    if misc.update_attributes(params[:misc])
      flash[:success] = "修改成功"
    else
      flash[:error] = misc.errors.full_messages
    end
    redirect_to :back
  end

  def destroy
  end

end