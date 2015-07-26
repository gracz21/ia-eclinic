class StaticPagesController < ApplicationController
  def home
    if current_patient
      @appointments = current_patient.appointments.where('day >= ?', Date.today).limit(10)
      find_doctors
      find_clinics
    end
    
    if current_doctor
      @appointments = Appointment.where(assignment_id: current_doctor.assignment_ids, day: Date.today, confirmed: true).order(:hour)
      @schedules = []
      current_doctor.assignments.each do |assignment|
        @schedules += assignment.schedules.where(weekday: Date.today.wday)
      end
      find_patients
      find_clinics
    end
    
    if current_admin
     @last_patients = Patient.all.order(created_at: :desc).limit(10)
     @last_doctors = Doctor.all.order(created_at: :desc).limit(10)
     @last_clinics = Clinic.all.order(created_at: :desc).limit(10)
     @appointments = Appointment.all.order(created_at: :desc).limit(10)
     find_patients
     find_doctors
     find_clinics
    end
  end
  
  private
    def find_patients
      @patients = []
      @appointments.each do |appointment|
        @patients << appointment.patient
      end
    end
    
    def find_doctors
      @doctors = []
      @appointments.each do |appointment|
        @doctors << appointment.assignment.doctor
      end
    end
    
    def find_clinics
      @clinics = []
      @appointments.each do |appointment|
        @clinics << appointment.assignment.clinic
      end
    end
end
