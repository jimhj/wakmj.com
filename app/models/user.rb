# coding: utf-8

class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::BaseModel
  include Mongoid::SecurePassword

  field :email, :type => String
  field :login, :type => String

  field :weibo_uid, :type => String, :default => ''
  field :weibo_token, :type => String, :default => ''

  field :last_signed_in_at, :type => Time

  validates :email, :presence => true, 
                    :uniqueness => true,
                    :format => { :with => /\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})\z/i }

  validates :login, :presence => true, :length => { :minimum => 2, :maximum => 20 }

  validates_length_of :password, :minimum => 6

  attr_accessible :email, :login, :weibo_token, :weibo_uid  

end