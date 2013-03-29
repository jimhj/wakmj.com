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
  field :renren_uid, :type => String, :default => ''
  field :renren_token, :type => String, :default => ''  

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

  def self.sync_to_weibo(user_id, tv_drama_id)
    begin
      logger.info "===============开始同步到新浪微博========"
      user = User.where(:_id => user_id).first
      tv_drama = TvDrama.where(:_id => tv_drama_id).first
      pic_path = File.join(Setting.pic_loc, tv_drama.cover_url(:large))
      tv_drama_url = "#{Setting.site_url}tv_dramas/#{tv_drama.id}"
      status = %Q(我正在追美剧 #{tv_drama.tv_name} 哦，感兴趣就一起追吧 #{tv_drama_url} @我爱看美剧网)

      conn = Faraday.new(:url => 'https://upload.api.weibo.com') do |faraday|
        faraday.request :multipart
        faraday.adapter :net_http
      end

      conn.post "/2/statuses/upload.json", {
        :access_token => user.weibo_token,
        :status => URI.encode(status),
        :pic => Faraday::UploadIO.new(pic_path, 'image/jpeg')
      }
    rescue => e
      logger.error "===============同步到新浪微博失败========"
      logger.error e.backtrace.join("\n")
    end
  end

  def self.sync_to_renren(user_id, tv_drama_id)
    begin
      logger.info "===============开始同步喜欢到人人========"
      user = User.where(:_id => user_id).first
      tv_drama = TvDrama.where(:_id => tv_drama_id).first
      tv_drama_url = "#{Setting.site_url}tv_dramas/#{tv_drama.id}"
      status = %Q(我正在追美剧 #{tv_drama.tv_name} 哦，感兴趣就一起追吧 #{tv_drama_url})

      conn = Faraday.new(:url => 'https://api.renren.com') do |faraday|
        faraday.response :logger
        faraday.request :url_encoded
        faraday.adapter :net_http
      end
      
      conn.post "restserver.do", {
        :access_token => user.renren_token,
        :method => "status.set",
        :v => '1.0',
        :format => 'json',
        :status => status
      }
    rescue => e
      logger.error "===============同步喜欢到人人失败========"
      logger.error e.backtrace.join("\n")
    end
  end       

  def like(likeable)
    return false if likeable.blank?
    return false if likeable.liked_by_user?(self)
    likeable.push(:liked_user_ids, self.id)
    likeable.inc(:likes_count, 1)
    likeable.touch
    
    if self.weibo_token.present?
      User.perform_async(:sync_to_weibo, self.id, likeable.id) 
    end

    if self.renren_token.present?
      User.perform_async(:sync_to_renren, self.id, likeable.id)
    end
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
      user = User.new
      user.email = email
      user.login = auth['name']
      user.password_confirmation = user.password = SecureRandom.hex(4)
      avatar_pic = auth['avatar_url']
      unless auth['avatar_url'].end_with?('.jpg')
        avatar_pic = "#{avatar_pic}/sample.jpg"
      end
      user.remote_avatar_url = avatar_pic
      user.weibo_uid = auth['weibo_uid']
      user.weibo_token = auth['weibo_token']
      user.renren_uid = auth['renren_uid']
      user.renren_token = auth['renren_token']      
      user.save ? user : nil
    end    

  end   

end