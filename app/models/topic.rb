# coding: utf-8

class Topic
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::BaseModel
  include Mongoid::CounterCache
  include Mongoid::Likeable
  
  field :title, :type => String
  field :content
  field :replies_count, :type => Integer, :default => 0

  belongs_to :user, :inverse_of => :topics
  belongs_to :tv_drama, :inverse_of => :topics
  has_many :replies

  counter_cache :name => :tv_drama, :inverse_of => :topics
  counter_cache :name => :user, :inverse_of => :topics

  index :user_id => 1
  index :tv_drama_id => 1

  validates_length_of :title, :minimum => 2, :maximum => 20
  validates_length_of :content, :minimum => 2, :maximum => 1000
  validates_presence_of :user_id, :tv_drama_id

  delegate :login, :to => :user, :prefix => true

end