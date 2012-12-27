# coding: utf-8
class Cpanel::ApplicationController < ApplicationController
  layout "cpanel"
  before_filter :require_login
  before_filter :require_admin

  def require_admin
    unless current_user.has_role?('admin')
      render_404
    end
  end
end
