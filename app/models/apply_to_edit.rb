# coding: utf-8

class ApplyToEdit
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::BaseModel
  include Mongoid::DelayedDocument

  field :user_id
  field :remarks

  # 0 , 1 pass, 2 reject.
  field :status, :type => Integer, :default => 0

  index :user_id => 1
  index :status => 1

  belongs_to :user
  delegate :login, :to => :user, :prefix => true

  validates_uniqueness_of :user_id

  def pass
    if self.update_attribute(:status, 1)
      self.user.push(:roles, "editor")
      self.user.touch
      true
    end
  end

  def pass?
    self.status == 1
  end

  def status_text
    case self.status
    when 0 then '未处理'
    when 1 then '已通过'
    when 2 then '已拒绝'
    end
  end

  after_update do
    if self.pass?
      p 1111111111111111111111
      ApplyToEdit.perform_async(:send_apply_notification, self.user_id)
    end       
  end

  def self.send_apply_notification(user_id)
    user = User.find_by_id(user_id)
    return if user.blank?
    Notification::Apply.create :user_id => user_id
  end  


  
end