# coding: utf-8

class EmailConfirmToken
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::BaseModel
  include Mongoid::DelayedDocument

  field :email
  field :token

  # unconfirm 0, confirmed 1
  field :status, :type => Integer, :default => 0


  def self.create_confirm_link(email)
    return unless User.where(:email => email).exists?
    token = Digest::MD5.hexdigest([Time.now.to_i.to_s, rand.to_s].join('-')).upcase
    if self.create(:email => email, :token => token)
      Setting.site_url + "confirm?type=password&email=#{email}&token=#{token}"
    else
      nil
    end
  end

  def self.send_confirm_link(email)
    link = self.create_confirm_link(email)
    puts link
    return if link.nil?
    begin
      UserMailer.send_confirm_link(email, link).deliver
    rescue Exception => e
      Logger.new("#{Rails.root}/log/mail.error.log").info(e.backtrace.join("\n"))
    end    
  end



end