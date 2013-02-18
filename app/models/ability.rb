class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    can :read, :all

    if user.role? :student
      can :manage, [Submission]
    end
    if user.role? :helper # or instructor
      can :manage, [Course]
    end
    if user.role? :admin
      can :manage, :all
    end
  end
end
