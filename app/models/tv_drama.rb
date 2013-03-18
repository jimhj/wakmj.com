# coding: utf-8

class TvDrama
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::BaseModel
  include Mongoid::TaggableOn
  include Mongoid::Likeable
  include Mongoid::DelayedDocument
  include Redis::Search

  # include Mongoid::CounterCache

  field :tv_name, :type => String
  # field :alias_name, :type => String, :default => ''
  field :cover, :type => String

  taggable_on :alias_names
  taggable_on :actors
  taggable_on :categories
  taggable_on :directors

  field :tv_station  
  field :release_date, :type => Time
  field :imdb
  field :summary
  field :topics_count, :type => Integer, :default => 0
  field :download_resources_count, :type => Integer, :default => 0 
  field :verify, :type => Boolean, :default => false
  field :created_by, :type => String, :default => ''
  field :last_edit_by, :type => String, :default => ''
  field :last_topic_id
  field :sort_no, :type => Integer, :default => 0
  
  field :finished, :type => Boolean, :default => false

  index :sort_no => -1
  index :verify => 1

  mount_uploader :cover, CoverUploader

  has_many :topics, :dependent => :destroy
  has_many :pre_releases, :dependent => :destroy
  has_many :replies, :dependent => :destroy
  has_many :articles, :dependent => :destroy

  embeds_many :download_resources

  validates :tv_name, :presence => true, :uniqueness => true
  validates_presence_of :cover

  scope :hots, desc(:likes_count)

  def last_topic
    Topic.find_by_id(self.last_topic_id)
  end

  def self.recents
    b_time = '20120101'.to_datetime.at_beginning_of_year
    e_time = b_time.at_end_of_year
    self.between(:release_date => b_time..e_time)   
  end

  redis_search_index(:title_field => :tv_name,
                     :score_field => :likes_count,
                     :condition_fields => [:verify],
                     :ext_fields => [:alias_names, :categories, :release_date, :topics_count, :likes_count])  

  after_create do |tv_drama|
    TvDrama.perform_async(:send_new_tv_drama, tv_drama.id)
  end

  def self.send_new_tv_drama(tv_drama_id)
    tv_drama = self.find_by_id(tv_drama_id)
    user_arys = User.all.to_a.in_groups_of(5, false)
    logger = Logger.new("#{Rails.root}/log/mail.error.log")
    user_arys.each do |users| 
      users.each do |user|
        begin
          logger.info("begin=====#{Time.now}===========")
          UserMailer.send_new_tv_drama(user, tv_drama).deliver
        rescue Exception => e
          logger.info("error=====#{Time.now}===========")
          logger.info(e.backtrace.join("\n"))
        end
      end
      sleep(60)
    end
  end

  def release_time
    self.release_date ? self.release_date.strftime('%F') : ''
  end

  def creator
    return nil if self.created_by.blank?
    User.find_by_id(self.created_by.to_i)
  end

  # def pre_releases
  # end

end