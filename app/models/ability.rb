class Ability
  include CanCan::Ability

  def initialize(user)
    @user = user || User.new # for guest
    @user.roles.each { |role| send(role) }
  end

  def admin
    can :manage, :all
  end

  def normal
    can :read, Document
  end

  def gold
    can :manage, Exercise
  end
end
