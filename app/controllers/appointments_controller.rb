class AppointmentsController < ApplicationController
  before_action :set_appointment, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    if current_patient
      @appointments = current_patient.appointments
    end
    if current_doctor
      @appointments = Appointment.where(assignment_id: current_doctor.assignment_ids)
    end
    if current_admin
      @appointments = Appointment.all
    end
    respond_with(@appointments)
  end

  def show
    respond_with(@appointment)
  end

  def new
    @appointment = Appointment.new
    assignments = Assignment.all
    @clinics = Clinic.where(id: assignments)
    @doctors = []
    respond_with(@appointment)
  end

  def edit
  end

  def create
    @appointment = Appointment.new(appointment_params)
    @appointment.save
    respond_with(@appointment)
  end

  def update
    @appointment.update(appointment_params)
    respond_with(@appointment)
  end
  
  def doctor_options
    if params[:clinic_id] != ''
      clinic = Clinic.find(params[:clinic_id])
      @doctors = Doctor.where(id: clinic.assignment_ids)
    else
      @doctors = []
    end
    respond_to do |format|
      format.js
    end
  end
  
  #current_time - current_time.sec - current_time.min%30*60 + 30.minutes
  
  def appointment_options
    @appointments = []
    if params[:day] != ''
      day = params[:day].to_date
      assignment = Assignment.where(clinic_id: params[:clinic_id], doctor_id: params[:doctor_id]).first
      schedules = Schedule.where(assignment_id: assignment.id, weekday: day.to_date.wday)
      registered_appointments = Appointment.where(assignment_id: assignment.id, day: day)
      schedules.each do |schedule|
        current = schedule.start_hour
        while current < schedule.end_hour do
          #cos
          current += 30.minutes
        end
      end
    end
    respond_to do |format|
      format.js
    end
  end

  def destroy
    @appointment.destroy
    respond_with(@appointment)
  end

  private
    def set_appointment
      @appointment = Appointment.find(params[:id])
    end

    def appointment_params
      params.require(:appointment).permit(:patient_id, :assignment_id, :day.to_date, :hour)
    end
end
