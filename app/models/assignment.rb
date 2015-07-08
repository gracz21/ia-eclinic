class Assignment < ActiveRecord::Base
  belongs_to :clinic
  belongs_to :doctor
  
  has_many :schedules
  has_many :appointments
end
