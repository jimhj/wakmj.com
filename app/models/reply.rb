# coding: utf-8

class Reply
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::BaseModel
  include Mongoid::CounterCache

  field :content
    
  embedded_in :topic
  belongs_to :user, :inverse_of => :replies
  belongs_to :tv_drama, :inverse_of => :replies

  counter_cache :name => :topic, :inverse_of => :replies  

  delegate :login, :to => :user, :prefix => true

  index :topic_id => 1
  index :user_id => 1
  index :tv_drama_id => 1


  
end