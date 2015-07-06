class Clinic < ActiveRecord::Base

  has_many :assignments
  has_many :doctors, :through => :assignments
  
  validates :name, presence: true
  
end
