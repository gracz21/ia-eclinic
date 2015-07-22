class Appointment < ActiveRecord::Base
  belongs_to :patient
  belongs_to :assignment
  
  validates :patient_id, :assignment_id, :day, :hour, presence: true
  validate :appointment_in_future
  
  private
    def appointment_in_future
      if day < Date.today
        errors.add(:day, "can't be date in past")
      end
      if day == Date.today and hour.strftime('%H%M') <= Time.zone.now.strftime('%H%M')
        errors.add(:hour, "has to be in future")
      end
    end
end
