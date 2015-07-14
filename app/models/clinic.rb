class Clinic < ActiveRecord::Base

  has_many :assignments, :dependent => :destroy
  has_many :doctors, :through => :assignments
  
  validates :name, presence: true
  
end
