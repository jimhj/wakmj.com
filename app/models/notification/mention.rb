# coding: utf-8
class Notification::Mention < Notification::Base
  belongs_to :mentionable, :polymorphic => true
  
  delegate :content, :to => :mentionable, :prefix => true, :allow_nil => true
  
  # def notify_hash
  #   return if self.mentionable.blank?
  #   { 
  #     :title => ["#{self.mentionable.user_login} ","提及你: "].join(""), 
  #     :content => self.mentionable_content[0,30]
  #   }
  # end
  
end
