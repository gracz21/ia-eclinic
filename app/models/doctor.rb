class Doctor < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable
  
  validates :first_name, :last_name, presence: true
  validates :pwz, presence: true, numericality: { only_integer: true },
    length: { minimum: 7,
              maximum: 7,
              too_short: "must have at least %{count} numbers",
              too_long: "must have at most %{count} numbers" }
end
