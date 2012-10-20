# coding: utf-8

class Misc
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::BaseModel
  field :title
  field :slug
  field :content
  field :category

  index(:category => 1)
  # index :created_at => -1

  validates_presence_of :title, :content, :category, :slug

  def category_name
    case self.category
    when "pages" then "网站单页"
    else
      "未分类"
    end
  end

  def self.find_by_slug(slug)
    where(:slug => slug).first
  end
    
end