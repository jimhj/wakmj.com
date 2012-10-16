# coding: utf-8

class Reply
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::BaseModel
  include Mongoid::CounterCache
  include Mongoid::Mentionable
  include Mongoid::DelayedDocument


  field :content
    
  belongs_to :topic, :inverse_of => :replies
  belongs_to :user, :inverse_of => :replies
  belongs_to :tv_drama, :inverse_of => :replies

  counter_cache :name => :topic, :inverse_of => :replies 
  counter_cache :name => :user, :inverse_of => :replies  

  delegate :login, :to => :user, :prefix => true

  index :topic_id => 1
  index :user_id => 1
  index :tv_drama_id => 1
  
  delegate :login, :to => :user, :prefix => true
  delegate :title, :to => :topic, :prefix => true
  
  scope :recent, desc('created_at').limit(10)

  # attr_accessible :content

  after_create do
    Reply.perform_async(:send_topic_reply_notification, self._id)
  end

  def self.send_topic_reply_notification(reply_id)
    reply = Reply.find_by_id(reply_id)
    return if reply.blank?
    topic = reply.topic
    return if topic.blank?

    if reply.user_id != topic.user_id && !reply.mentioned_user_ids.include?(topic.user_id)
      Notification::TopicReply.create :user_id => topic.user_id, :reply_id => reply.id
      reply.notified_user_ids << topic.user_id
    end
  end



  
end