class Ability
  include CanCan::Ability

  def initialize(user)
    @user = user || User.new # for guest
    @user.roles.each { |role| send(role) }
  end

  def master
    can :manage, :all
  end

  def admin
    can :manage, :all
  end

  def user
    can :read, Notification
  end

  def documenter
    can :manage, Document
  end
end
