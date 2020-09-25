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
      can %i[read update], Admin, hospital_id: user.hospital_id, id: user.id
      can %i[read], Appointment, hospital_id: user.hospital_id
    elsif user.doctor?
      can :index, Patient, Patient.doctor_only(user) do |patient|
        patient
      end
      can :show, Patient do |patient|
        patient.hospital_id == user.hospital_id && patient.appointment.doctor_id == user.id
      end
      can :read, Doctor, hospital_id: user.hospital_id, id: user.id
      can :update, Doctor, hospital_id: user.hospital_id, id: user.id
      can :manage, Availability, hospital_id: user.hospital_id, doctor_id: user.id
      can %i[read cancel approve complete], Appointment, hospital_id: user.hospital_id, doctor_id: user.id
    elsif user.patient?
      can :show, Patient, hospital_id: user.hospital_id, id: user.id
      can :update, Patient, hospital_id: user.hospital_id, id: user.id
      can :read, Doctor, hospital_id: user.hospital_id
      can %i[read create cancel show_availabilities], Appointment, hospital_id: user.hospital_id, patient_id: user.id
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
