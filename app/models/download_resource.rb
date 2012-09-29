# coding: utf-8

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

  counter_cache :name => :tv_drama, :inverse_of => :download_resources
  counter_cache :name => :user, :inverse_of => :download_resources

  

end