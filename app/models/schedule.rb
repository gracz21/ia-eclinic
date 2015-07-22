class Schedule < ActiveRecord::Base
  belongs_to :assignment
  
  validates :weekday, :inclusion => {:in => 1..5}, presence: true
  validates :assignment_id, :start_hour, :end_hour, presence: true
  validate :check_start_end_correctness, :check_cohesion
  
  private
  
    def check_start_end_correctness
      if start_hour.strftime('%H%M') >= end_hour.strftime('%H%M')
        errors.add(:end_hour, "can't be later than start hour")
      end
    end
    
    def check_cohesion
      schedules = []
      Assignment.where(doctor_id: assignment.doctor_id).each do |assignment|
        schedules += assignment.schedules
      end
      if !id.nil?
        schedules -= Schedule.where(id)
      end
      schedules.each do |tmp|
        if tmp.weekday == weekday
          if !(end_hour.strftime('%H%M') <= tmp.start_hour.strftime('%H%M') or
            start_hour.strftime('%H%M') >= tmp.end_hour.strftime('%H%M'))
            errors.add(:start_hour, "schedule registry for this hour already exists")
            errors.add(:end_hour, "schedule registry for this hour already exists")
          end
        end
      end
    end
end
