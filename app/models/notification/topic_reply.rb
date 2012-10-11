# coding: utf-8
class Notification::TopicReply < Notification::Base
  belongs_to :reply  
  delegate :content, :to => :reply, :prefix => true, :allow_nil => true
  
end
