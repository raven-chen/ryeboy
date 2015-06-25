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
  end

  def student
    can :read, Notification
    can :manage, Topic
    can :manage, Exercise
    cannot :unfinished, Exercise
    can :read, Document
  end

  def mentor
    can :read, Notification
    can :manage, Topic
    can :manage, Exercise
    can :read, User
    can :read, Document
    can :read, Post
  end

  # Functional roles
  def admin
    can :manage, :all
  end

  def documenter
    can :manage, Document
    can :access, :rails_admin
    can :dashboard
  end

  def hr
    can :manage, User
  end
end
