class Test < ApplicationRecord
	has_many :bill_details as: :billable, dependent: :nullify
	has_many :lab_reports, dependent: :nullify
	has_many :bills, through: :bill_details
    belongs_to :hospital

end
