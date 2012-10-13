# coding: utf-8
class UserMailer < ActionMailer::Base
  default :from => "我爱看美剧 <webmaster@wakmj.com>"

  def sign_up(user)
    @user = user
    mail(:to => @user.email, :subject => "欢迎您注册 - #{SITE_NAME}")
  end

end
