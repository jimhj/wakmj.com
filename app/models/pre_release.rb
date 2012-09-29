# coding: utf-8

class PreRelease
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::BaseModel

  field :tv_name
  field :season
  field :episode
  field :release_date

  belongs_to :tv_drama
  
end