class Assignment < ActiveRecord::Base
  belongs_to :clinic
  belongs_to :doctor
  
  has_many :schedules, :dependent => :destroy
  has_many :appointments, :dependent => :destroy
end
