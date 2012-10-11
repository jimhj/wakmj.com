# coding: utf-8
class Notification::Base
  include Mongoid::Document
  include Mongoid::Timestamps::Created

  store_in :collection => 'notifications'

  field :readed, :default => false
  belongs_to :user

  index :readed => 1
  index :user_id => 1, :readed => 1

  scope :unread, where(:read => false)

end
