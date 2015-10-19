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
    can :read, Document
    can :update_self, User
    can :read, Task
  end

  def student
    can :read, Notification
    can :manage, Topic
    can :manage, Exercise
    cannot :unfinished, Exercise
    can :read, Document
    can :read, Task
    can :update_self, User
  end

  def mentor
    can :read, Notification
    can :manage, Topic
    can :manage, Exercise
    can :read, User
    can :read, Document
    can :manage, Post
    can :read, Task
    can :update_self, User
  end

  # Functional roles
  def admin
    can :manage, :all
  end

  def documenter
    can :manage, Document
    can :dashboard
  end

  def hr
    can :manage, User
  end

  def dean
    can :manage, Task
  end
end
