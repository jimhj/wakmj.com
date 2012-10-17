# coding: utf-8
require 'open-uri'
require 'net/http'

class DownloadResource
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::BaseModel
  include Mongoid::CounterCache
  
  field :link_text
  field :season
  field :episode
  field :episode_size
  field :episode_format
  field :download_link

  belongs_to :user
  embedded_in :tv_drama

  index :user_id => 1

  counter_cache :name => :tv_drama, :inverse_of => :download_resources
  counter_cache :name => :user, :inverse_of => :download_resources

  validates_presence_of :link_text, :season, :episode, :episode_size, :episode_format, :download_link

  validate :check_download_link

  def check_download_link
    unless self.download_link.blank?
      url = URI.parse(self.download_link)
      p url.host
      unless Net::HTTP.start(url.host, url.port) { |http| return http.head(url.request_uri).code == '200' }
        errors[:download_link] << "下载链接是无效的链接，请检查"
      end
    end
  end
   

end