class Ability
  include CanCan::Ability

  def initialize(user)
    @user = user || User.new # for guest
    @user.roles.each { |role| send(role) }
  end

  def admin
    can :manage, :all
  end

  def newbie
    can :manage, Topic
  end

  def student
    can :read, Notification
  end

  def mentor
    can :read, Notification
  end

  def documenter
    can :manage, Document
  end

  def hr
    can :manage, User
  end
end
