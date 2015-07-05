class Clinic < ActiveRecord::Base
  
  has_and_belongs_to_many :doctors
  
  validates :name, presence: true
  
end
