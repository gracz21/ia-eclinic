class AppointmentsController < ApplicationController
  include ApplicationHelper
  include AppointmentsHelper
  before_action :is_logged_in
  before_action :set_appointment, only: [:show, :edit, :update, :confirm_appointment,
    :destroy]
  before_action :is_patient, only: [:new, :create, :doctor_options, 
    :get_assignment_id, :hour_options, :first_free_clinic, :first_free_doctor,
    :confirm_appointment]
  before_action :is_not_doctor, only: [:destroy]
  before_action :is_authorized_patient, only: :show
  before_action :is_authorized_doctor, only: :show

  respond_to :html

  def index
    @patients = []
    @doctors = []
    @clinics = []
    if current_patient
      @appointments = current_patient.appointments
      @confirmation_dates = []
      @appointments.each do |appointment|
        @confirmation_dates << (appointment.created_at + 10.minutes).strftime('%Y/%m/%d %H:%M:%S')
      end
      find_doctors
    end
    if current_doctor
      @appointments = Appointment.where(assignment_id: current_doctor.assignment_ids, confirmed: true).order(:day, :hour)
      find_patients
    end
    if current_admin
      @appointments = Appointment.all
      find_patients
      find_doctors
    end
    find_clinics
    respond_with(@appointments)
  end

  def show
    @patient = @appointment.patient
    @clinic = @appointment.assignment.clinic
    @doctor = @appointment.assignment.doctor
    respond_with(@appointment)
  end

  def new
    @appointment = Appointment.new
    appointment_form
    respond_with(@appointment)
  end

  def edit
  end

  def create
    @appointment = current_patient.appointments.build(appointment_params)
    begin
      if @appointment.save
        DeleteAppointmentWorker.perform_at(10.minutes.from_now, @appointment.id)
        redirect_to @appointment
      else
        appointment_form
        render :new
      end
      rescue Exception
        appointment_form
        render :new, notice: "An error has occured while saving appointment"
    end
  end

  def update
    @appointment.update(appointment_params)
    respond_with(@appointment)
  end
  
  def doctor_options
    if params[:clinic_id] != ''
      clinic = Clinic.find(params[:clinic_id])
      @doctors = clinic.doctors
    else
      @doctors = []
    end
    respond_to do |format|
      format.js
    end
  end
  
  def get_assignment_id
    @assignment_id = Assignment.where(clinic_id: params[:clinic_id],
                                      doctor_id: params[:doctor_id]).first.id
    respond_to do |format|
      format.js
    end
  end
  
  def hour_options
    if params[:day] != ''
      day = params[:day].to_date
      assignment = Assignment.where(clinic_id: params[:clinic_id], doctor_id: params[:doctor_id]).first
      schedules = assignment.schedules.where(weekday: day.wday)
      appointments = assignment.appointments.where(day: day)
      gen_free_hours(day, schedules, appointments)
    end
    respond_to do |format|
      format.js
    end
  end
  
  def first_free_clinic
    gen_free_hours_for_clinic(Clinic.find(params[:clinic_id]))
    @appointment = current_patient.appointments.build(assignment_id: @appointment_data.assignment_id,
                                                      hour: @appointment_data.hour,
                                                      day: @appointment_data.day)
    @appointment.save
    DeleteAppointmentWorker.perform_at(10.minutes.from_now, @appointment.id)
    respond_with(@appointment)
  end
  
  def first_free_doctor
    gen_free_hours_for_doctor(Doctor.find(params[:doctor_id]), nil)
    @appointment = current_patient.appointments.build(assignment_id: @assignment_id,
                                                      hour: @hour, day: @day)
    @appointment.save
    DeleteAppointmentWorker.perform_at(10.minutes.from_now, @appointment.id)
    respond_with(@appointment)
  end
  
  def confirm_appointment
    if @appointment.created_at + 10.minutes >= Time.now
      @appointment.confirmed = true
      @appointment.save
    end
    redirect_to(:back)
  end

  def destroy
    if (@appointment.day < Date.today) or (@appointment.day == Date.today and @appointment.hour.strftime('%H%M') < Time.zone.now.strftime('%H%M'))
      redirect_to :back, notice: "You can't delete appointments from past"
    else
      @appointment.destroy
      respond_with(@appointment)
    end
  end

  private
    def set_appointment
      @appointment = Appointment.find(params[:id])
    end
    
    def find_patients
      @appointments.each do |appointment|
        @patients << appointment.patient
      end
    end
    
    def find_doctors
      @appointments.each do |appointment|
        @doctors << appointment.assignment.doctor
      end
    end
    
    def find_clinics
      @appointments.each do |appointment|
        @clinics << appointment.assignment.clinic
      end
    end

    def appointment_params
      params.require(:appointment).permit(:assignment_id, :day, :hour)
    end
    
    def appointment_form
      @clinics = []
      Clinic.all.each do |clinic|
        if clinic.assignments.size > 0
          @clinics << clinic
        end
      end
      @doctors = []
      @hours = []
    end
end
