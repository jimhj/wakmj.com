# coding: utf-8
class Notification::Apply < Notification::Base
  
  def system_user
    User.where(:login => 'laohuang').first
  end
  
end
