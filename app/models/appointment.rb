class Appointment < ActiveRecord::Base
  belongs_to :patient
  belongs_to :assignment
  
  validates :patient_id, :assignment_id, :day, :hour, presence: true
end
