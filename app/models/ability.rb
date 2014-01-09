class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    if user.admin
      can :access, :rails_admin   # grant access to rails_admin
      can :dashboard
      can :manage, :all
      cannot [:delete, :destroy], Category
    end
  end
end
