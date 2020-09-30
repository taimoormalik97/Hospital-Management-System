module DoctorHelper
  def list_of_doctors_with_speciality(doctors, speciality)
    speciality.present? ? doctors.where(speciality: speciality) : doctors
  end
end
