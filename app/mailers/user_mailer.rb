# coding: utf-8
class UserMailer < ActionMailer::Base
  default :from => "我爱看美剧 <webmaster@wakmj.com>"

  def sign_up(user)
    @user = user
    mail(:to => @user.email, :subject => "欢迎您注册 - #{SITE_NAME}")
  end

  def send_confirm_link(email, link)
    @email = email
    @link = link
    mail(:to => @email, :subject => "密码重置邮件 - #{SITE_NAME}")
  end

  def send_new_tv_drama(user, tv_drama)
    @user = user
    @tv_drama = tv_drama
    @image_host = Setting.site_url.sub(/\/$/, '')
    mail(:to => @user.email, :subject => "有新美剧啦！ - #{SITE_NAME}")
  end

end
