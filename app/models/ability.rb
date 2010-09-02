class Ability
  include CanCan::Ability

  def initialize(user)
    if user.role? :admin
      can :manage, :all
    elsif user.role?(:activity_manager)
      can :approve, Activity
      #can :approve, Activity do |activity|
        #activity.try(:organization) == user.organization
      #end
      can :manage, Project
      can :manage, FundingFlow
      can :manage, Organization
      can :manage, Activity
      can :manage, OtherCost
      can :manage, Comment
      can :manage, CodeAssignment
      can :create, Organization
      can :update, User, :id => user.id
      can :read, Code
      can :read, ModelHelp
      can :read, FieldHelp
      can :create, HelpRequest
    elsif user.role?(:reporter)
      can :manage, Project
      can :manage, FundingFlow
      can :manage, Organization
      can :manage, Activity
      can :manage, OtherCost
      can :manage, Comment
      can :manage, CodeAssignment
      can :create, Organization
      can :update, User, :id => user.id
      can :read, Code
      can :read, ModelHelp
      can :read, FieldHelp
      can :create, HelpRequest
    else #guest user
      can :create, HelpRequest
    end
  end
end
