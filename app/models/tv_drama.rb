# coding: utf-8

class TvDrama
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::BaseModel
  include Mongoid::TaggableOn

  field :tv_name, :type => String
  field :alias_name, :type => String, :default => ''
  field :cover, :type => String

  taggable_on :actors, :index => false
  taggable_on :categories
  taggable_on :directors

  field :release_date, :type => Time
  field :summary

  field :verify, :type => Boolean, :default => false

  mount_uploader :cover, CoverUploader

  has_many :topics

  validates_presence_of :tv_name

end