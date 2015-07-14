class Seed

  def self.run
    admin
    doc
    patient
    clinic
  end
  
  private
  
  def self.admin
    Admin.create!(email: 'admin@example.com',
                  password: 'admin12',
                  password_confirmation: 'admin12')
  end
  
  def self.doc
    Doctor.create!(email: 'doc@example.com',
                   password: 'admin12',
                   password_confirmation: 'admin12',
                   first_name: 'Gregory',
                   last_name: 'House',
                   pwz: '5425740')
  end
  
  def self.patient
    Patient.create!(email: 'patient@example.com',
                    password: 'admin12',
                    password_confirmation: 'admin12',
                    first_name: 'Zdzichu',
                    last_name: 'Krawężnik',
                    pesel: '00010137489',
                    address: 'Januszowo',
                    approved: true)
  end
  
  def self.clinic
    Clinic.create!(name: 'Princeton-Plainsboro')
    Clinic.create!(name: 'Szpital w Leśnej Górze')
  end
  
end

Seed::run