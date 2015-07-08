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
    @clinics = Clinic.all
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
    clinic = Clinic.find(params[:clinic_id])
    @doctors = Doctor.where(id: clinic.assignment_ids)
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
      params.require(:appointment).permit(:patient_id, :assignment_id, :day, :hour)
    end
end
