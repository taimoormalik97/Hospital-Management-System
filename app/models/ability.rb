# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    user ||= User.new # guest user (not logged in)
    if user.admin?
      can :manage, Patient, hospital_id: user.hospital_id
      can :manage, Doctor, hospital_id: user.hospital_id
      can :manage, Medicine, hospital_id: user.hospital_id
      can :manage, PurchaseOrder, hospital_id: user.hospital_id
      can :manage, Bill, hospital_id: user.hospital_id
      #ability to not delete a medicine if it exists in a purchase detail
      cannot :destroy, Medicine do |medicine|
        PurchaseDetail.where(medicine_id: medicine.id).exists? || BillDetail.where(billable_id: medicine.id).exists?
      end
      
      can %i[read update], Admin, hospital_id: user.hospital_id, id: user.id

    elsif user.doctor?
      can :read, Patient, hospital_id: user.hospital_id # add appointment ability
      can :read, Doctor, hospital_id: user.hospital_id, id: user.id
      can :update, Doctor, hospital_id: user.hospital_id, id: user.id
    elsif user.patient?
      can :show, Patient, hospital_id: user.hospital_id, id: user.id
      can :update, Patient, hospital_id: user.hospital_id, id: user.id
      can :read, Doctor, hospital_id: user.hospital_id
    end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
  end
end
