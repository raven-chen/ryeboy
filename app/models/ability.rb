class Ability
  include CanCan::Ability

  def initialize(user)
    @user = user || User.new # for guest
    @user.roles.each { |role| send(role) }

    alias_action :create, :edit, :read, :update, :destroy, :to => :crud
  end

  # fundamental roles
  def newbie
    can :crud, Topic
    can [:crud, :like, :dislike, :my], Exercise
    can :read, Document
    can :update_self, User
    can :read, Task
    can [:read, :list_view], Notification
  end

  def student
    can [:read, :list_view], Notification
    can :crud, Topic
    can [:crud, :like, :dislike, :my], Exercise
    can :read, Document
    can :read, Task
    can :update_self, User
  end

  def mentor
    can [:read, :list_view], Notification
    can :crud, Topic
    can :manage, Exercise
    can :read, User
    can :read, Document
    can :crud, Post
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

  def editor
    can :manage, HomepageItem
  end
end
