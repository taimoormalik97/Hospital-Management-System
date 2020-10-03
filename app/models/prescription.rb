class Prescription < ApplicationRecord
  sequenceid :hospital, :prescriptions
  belongs_to :appointment
  belongs_to :hospital
  has_many :prescribed_medicines, dependent: :destroy
  has_many :medicines, through: :prescribed_medicines
  
  def self.available_prescriptions(user)
    if user.doctor?
      where(appointments: { doctor_id: user.id })
    elsif user.patient?
      where(appointments: { patient_id: user.id })
    else
      all
    end
  end

end
