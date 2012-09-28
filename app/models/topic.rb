# coding: utf-8

class Topic
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::BaseModel
  
  field :title, :type => String
  field :content

  belongs_to :user, :inverse_of => :topics
  belongs_to :tv_drama, :inverse_of => :topics
  has_many :replies

  index :user_id => 1
  index :tv_drama_id => 1

end