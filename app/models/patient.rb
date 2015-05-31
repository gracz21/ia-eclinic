class Patient < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         
  validates :first_name, :last_name, :address, presence: true
  validates :pesel, presence: true, numericality: { only_integer: true },
    length: { minimum: 11,
              maximum: 11,
              too_short: "must have at least %{count} numbers",
              too_long: "must have at most %{count} numbers" }
              
    def active_for_authentication? 
      super && approved? 
    end 
  
    def inactive_message 
      if !approved? 
        :not_approved 
      else 
        super 
      end 
    end
  
end
