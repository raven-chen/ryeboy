class Ability
  include CanCan::Ability

  def initialize(user)
    @user = user || User.new # for guest
    @user.roles.each { |role| send(role) }
  end

  # fundamental roles
  def newbie
    can :manage, Topic
    can :manage, Exercise
    cannot :unfinished, Exercise
  end

  def student
    can :read, Notification
    can :manage, Topic
    can :manage, Exercise
    cannot :unfinished, Exercise
  end

  def mentor
    can :read, Notification
    can :manage, Topic
    can :manage, Exercise
    can :read, User
  end

  # Functional roles
  def admin
    can :manage, :all
  end

  def documenter
    can :manage, Document
  end

  def hr
    can :manage, User
  end
end
