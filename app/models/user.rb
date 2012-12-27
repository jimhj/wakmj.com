# coding: utf-8

class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::BaseModel
  include Mongoid::SecurePassword
  include Mongoid::DelayedDocument

  field :email, :type => String
  field :login, :type => String
  field :avatar, :type => String, :default => ''
  
  field :topics_count, :type => Integer, :default => 0
  field :replies_count, :type => Integer, :default => 0
  field :download_resources_count, :type => Integer, :default => 0
  field :notifications_count, :type => Integer, :default => 0

  field :weibo_uid, :type => String, :default => ''
  field :weibo_token, :type => String, :default => ''

  field :last_signed_in_at, :type => Time
  field :roles, :type => Array, :default => ['member']

  index :email => 1
  index :login => 1

  has_many :topics, :dependent => :destroy
  has_many :notifications, :class_name => 'Notification::Base', :dependent => :destroy
  has_many :replies, :dependent => :destroy

  validates :email, :presence => true, 
                    :uniqueness => true,
                    :format => { :with => /\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})\z/i }
  validates_length_of :login, :minimum => 2, :maximum => 20
  # validates_length_of :password, :minimum => 6
  validates_uniqueness_of :login

  attr_accessible :email, :login, :weibo_token, :weibo_uid, :roles

  mount_uploader :avatar, AvatarUploader

  def has_role?(role)
    return true if self.roles.include?('superadmin')
    case role
    when 'admin' then admin?
    else      
      self.roles.include?(role)
    end
  end

  def admin?
    Setting.admin_user_emails.include?(self.email)
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

  def read_notifications(notifications)
    unread_ids = notifications.find_all{ |notification| !notification.readed? }.map(&:_id)
    if unread_ids.any?
      Notification::Base.where({
        :user_id => self.id,
        :_id.in  => unread_ids,
        :readed    => false
      }).update_all(:readed => true)
    end    
  end

  def unread_notifications_count
    self.notifications.where(:readed => false).count
  end

  def self.send_sign_up_mail(user_id)
    user = self.find_by_id(user_id)
    begin
      UserMailer.sign_up(user).deliver
    rescue Exception => e
      Logger.new("#{Rails.root}/log/mail.error.log").info(e)
      # Rails.logger.error e
    end
  end


  class << self

    def authenticate(email, password)
      user = self.where(:email => email).first
      return nil if user.nil?
      user.password == password ? user : nil
    end
    
    def create_by_email_and_auth(email, auth)
      weibo_uid = auth['uid']
      return nil if weibo_uid.blank?
      user = User.new
      user.email = email
      user.login = auth['name']
      user.password_confirmation = user.password = SecureRandom.hex(4)
      user.remote_avatar_url = "#{auth['avatar_url']}/sample.jpg"
      user.weibo_uid = weibo_uid
      user.weibo_token = auth['weibo_token']
      if user.valid?
        user.save
        user
      else
        nil
      end
    end    

  end   

end