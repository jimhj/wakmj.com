# coding: utf-8

class TvDrama
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::BaseModel
  include Mongoid::TaggableOn

  field :tv_name, :type => String
  field :alias_name, :type => String, :default => ''
  field :cover, :type => String

  taggable_on :alias_names
  taggable_on :actors
  taggable_on :categories
  taggable_on :directors

  field :tv_station  
  field :release_date, :type => Time
  field :summary

  field :verify, :type => Boolean, :default => false

  mount_uploader :cover, CoverUploader

  has_many :topics

  validates :tv_name, :presence => true, 
                      :uniqueness => true

end