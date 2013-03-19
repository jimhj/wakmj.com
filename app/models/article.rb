# coding: utf-8

class Article
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::BaseModel

  field :title
  field :content
  field :summary
  field :from
  field :source_link

  belongs_to :tv_drama, :inverse_of => :articles
  has_many :comments, :as => :commentable, :dependent => :destroy

  attr_accessible :title, :content, :summary, :from
  validates_presence_of :title, :content, :summary, :from
  validates_uniqueness_of :title

end