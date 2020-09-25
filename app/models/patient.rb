class Patient < User
  has_many :appointments, dependent: :nullify
  has_many :doctors, through: :appointments
  has_many :lab_reports, dependent: :nullify
  has_many :bills, dependent: :nullify
  validates_presence_of %i[name gender dob]
  validates :name, length: { in: 3..35 }
  scope :doctor_only, ->(user) { joins(:appointments).where(appointments: { doctor_id: user.id, hospital_id: user.hospital_id }) }
end
