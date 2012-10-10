# coding: utf-8

class PreRelease
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include Mongoid::BaseModel

  # field :tv_name
  field :season
  field :episode
  field :release_date

  belongs_to :tv_drama, :inverse_of => :pre_releases

  index :tv_drama_id => 1

  validates_presence_of :season, :episode, :release_date
  attr_accessible :season, :episode, :release_date

  def season_epi
    self.season + self.episode
  end

  def release_day_of_week
    # TODO: do this in il8n.
    case self.release_date.strftime('%u').to_i
      when 1 then '周一'
      when 2 then '周二'
      when 3 then '周三'
      when 4 then '周四'
      when 5 then '周五'
      when 6 then '周六'
      when 7 then '周日'
    end
  end

  def self.recent
    uniq_ids = PreRelease.desc('created_at').distinct(:tv_drama_id)[0..11]
    self.where(:tv_drama_id.in => uniq_ids).includes(:tv_drama).limit(12)
  end

  
end