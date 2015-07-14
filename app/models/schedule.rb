class Schedule < ActiveRecord::Base
  belongs_to :assignment
  
  validates :weekday, :inclusion => {:in => 1..5}, presence: true
  validates :start_hour, :end_hour, presence: true
end
