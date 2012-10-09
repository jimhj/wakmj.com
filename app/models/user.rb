# coding: utf-8

class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::BaseModel
  include Mongoid::SecurePassword

  field :email, :type => String
  field :login, :type => String
  field :avatar, :type => String, :default => ''
  
  field :topics_count, :type => Integer, :default => 0
  field :download_resources_count, :type => Integer, :default => 0

  field :weibo_uid, :type => String, :default => ''
  field :weibo_token, :type => String, :default => ''

  field :last_signed_in_at, :type => Time
  field :roles, :type => Array, :default => ['member']

  index :email => 1
  index :login => 1

  has_many :topics

  validates :email, :presence => true, 
                    :uniqueness => true,
                    :format => { :with => /\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})\z/i }
  validates :login, :presence => true, :length => { :minimum => 2, :maximum => 20 }
  validates_length_of :password, :minimum => 6

  attr_accessible :email, :login, :weibo_token, :weibo_uid

  mount_uploader :avatar, AvatarUploader

  def has_role?(role)
    self.roles.include?(role)
  end

  def like(likeable)
    return false if likeable.blank?
    return false if likeable.liked_by_user?(self)
    likeable.push(:liked_user_ids, self.id)
    likeable.inc(:likes_count, 1)
    likeable.touch
  end

  def unlike(likeable)
    return false if likeable.blank?
    return false if not likeable.liked_by_user?(self)
    likeable.pull(:liked_user_ids, self.id)
    likeable.inc(:likes_count, -1)
    likeable.touch
  end


  class << self

    def authenticate(email, password)
      user = self.where(:email => email).first
      return nil if user.nil?
      user.password == password ? user : nil
    end

  end   

end