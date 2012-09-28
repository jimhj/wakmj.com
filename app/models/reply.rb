# coding: utf-8

class Reply
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::BaseModel
    
  belongs_to :topic, :inverse_of => :repies
  
end