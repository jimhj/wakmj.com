# coding: utf-8

class Reply
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::BaseModel
  include Mongoid::CounterCache
    
  belongs_to :topic, :inverse_of => :replies
  counter_cache :name => :topic, :inverse_of => :replies
  
end