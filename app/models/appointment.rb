class Appointment < ApplicationRecord
  include ActiveModel::Transitions

  state_machine initial: :pending do
    state :pending
    state :approved
    state :completed
    state :canceled
    event :approve do
      transitions to: :approved, from: :pending
    end
    event :complete do
      transitions to: :completed, from: :approved
    end
    event :cancel do
      transitions to: :canceled, from: :pending
      transitions to: :canceled, from: :approved
    end
  end

  sequenceid :hospital, :appointments
  belongs_to :hospital
  belongs_to :doctor
  belongs_to :patient
  belongs_to :availability
  has_one :prescription, dependent: :destroy
  validates_uniqueness_of :date, scope: :availability_id
  validates_presence_of :date

  def get_persisted_prescription
    Prescription.find_by(appointment_id: id)
  end
  
end
