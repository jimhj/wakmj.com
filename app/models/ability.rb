class Ability
  include CanCan::Ability

  def initialize(user)

    if user.blank?
      cannot :manage, :all
      basic_read_only
    elsif user.has_role?('superadmin')
      can :manage, :all
      basic_read_only
    elsif user.has_role?('member')
      # Like
      can :like, :resources
      # Downloads
      can :create, DownloadResource
      
      # Topic
      can :create, Topic
      can :update, Topic do |topic|
        (topic.user_id == user.id)
      end
      can :destroy, Topic do |topic|
         (topic.user_id == user.id)
      end

      # Reply
      can :create, Reply
      can :update, Reply do |reply|
        reply.user_id == user.id
      end
      can :destroy, Reply do |reply|
        reply.user_id == user.id
      end

      # Comment 
      can :create, Comment
      can :update, Comment do |comment|
        comment.user_id == user.id
      end
      can :destroy, Comment do |comment|
        comment.user_id == user.id
      end

      if user.has_role?('editor')
        can :create, TvDrama
        can :update, TvDrama        
      end   

      basic_read_only
    else
      cannot :manage, :all
      basic_read_only      
    end


  end

  protected

  def basic_read_only
    can :read, TvDrama
    can :read, Topic
    can :read, Reply
    can :read, User
  end  

end
