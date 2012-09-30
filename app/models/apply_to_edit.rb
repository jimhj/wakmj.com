# coding: utf-8

class ApplyToEdit
  include Mongoid::Document
  include Mongoid::Timestamps

  field :user_id
  field :remarks

  # 0 , 1 pass, 2 reject.
  field :status, :type => Integer, :default => 0

  index :user_id => 1
  index :status => 1

  def pass
    if self.update_attribute(:status, 1)
      User.find_by_id(self.user_id).update_attribute(:role, 'EDITOR')
    end
  end
  
end