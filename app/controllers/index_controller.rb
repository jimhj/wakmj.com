# coding: utf-8
class IndexController < ApplicationController
  before_filter :check_signed_in, :only => [:sign_up, :sign_in]

  def index
  end

  def sign_up
  end

  def sign_in
  end

  def sign_out
  end

  private

  def check_signed_in
    redirect_to :root if signed_in?
    return
  end

end