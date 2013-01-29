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
  field :sync_to_weibo, :type => Boolean, :default => false

  belongs_to :user, :inverse_of => :topics
  belongs_to :tv_drama, :inverse_of => :topics
  has_many :replies, :dependent => :destroy

  counter_cache :name => :tv_drama, :inverse_of => :topics
  counter_cache :name => :user, :inverse_of => :topics

  index :user_id => 1
  index :tv_drama_id => 1

  validates_length_of :title, :minimum => 2, :maximum => 20
  validates_length_of :content, :minimum => 2, :maximum => 10000
  validates_presence_of :user_id, :tv_drama_id

  delegate :login, :to => :user, :prefix => true
  # scope :recent, desc('created_at').limit(10)

  def last_replier
    User.find_by_id(self.last_replied_user_id)
  end

  def self.recent
    self.includes(:user).desc('created_at').limit(10)
  end

  after_create do
    if self.sync_to_weibo? && self.user.weibo_token.present?
      # Topic.sync_to_weibo(self)
       Reply.perform_async(:sync_to_weibo, self)
    end
  end

  def self.sync_to_weibo(topic)
    pic_path = File.join(Setting.pic_loc, topic.tv_drama.cover_url(:large))
    topic_url = "#{Setting.site_url}/topics/#{topic.id}"
    status = %Q(我在美剧 #{topic.tv_drama.tv_name} 中发表了主题 《#{topic.title}》#{topic_url} @我爱看美剧网)

    conn = Faraday.new(:url => 'https://upload.api.weibo.com') do |faraday|
      faraday.request :multipart
      faraday.adapter :net_http
    end

    conn.post "/2/statuses/upload.json", {
      :access_token => topic.user.weibo_token,
      :status => URI.encode(status),
      :pic => Faraday::UploadIO.new(pic_path, 'image/jpeg')
    }
    
  end  


end