class Schedule < ActiveRecord::Base
  belongs_to :assignment
  
  validates :weekday, :inclusion => {:in => 0..4}, presence: true
  validates :start_hour, :end_hour, presence: true
end
