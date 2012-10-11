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

  field :last_replied_user_id
  field :last_replied_at, :type => Time

  belongs_to :user, :inverse_of => :topics
  belongs_to :tv_drama, :inverse_of => :topics
  has_many :replies, :dependent => :destroy

  counter_cache :name => :tv_drama, :inverse_of => :topics
  counter_cache :name => :user, :inverse_of => :topics

  index :user_id => 1
  index :tv_drama_id => 1

  validates_length_of :title, :minimum => 2, :maximum => 20
  validates_length_of :content, :minimum => 2, :maximum => 1000
  validates_presence_of :user_id, :tv_drama_id

  delegate :login, :to => :user, :prefix => true
  scope :recent, desc('created_at').limit(10)

  def last_replier
    User.find_by_id(self.last_replied_user_id)
  end

  # def self.recent
  #   Topic.desc('created_at').limit(10)
  # end

end