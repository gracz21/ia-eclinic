class AppointmentsController < ApplicationController
  include ApplicationHelper
  before_action :is_logged_in
  before_action :set_appointment, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @patients = []
    @doctors = []
    if current_patient
      @appointments = current_patient.appointments
      find_doctors
    end
    if current_doctor
      @appointments = Appointment.where(assignment_id: current_doctor.assignment_ids)
      find_patients
    end
    if current_admin
      @appointments = Appointment.all
      find_patients
      find_doctors
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
    @hours = []
    respond_with(@appointment)
  end

  def edit
  end

  def create
    @appointment = current_patient.appointments.build(appointment_params)
    #@assignment = Assignment.where(assignment_params).first
    #if @appointment.valid?
      #@assignment.appointments << @appointment
    #end
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
  
  def get_assignment_id
    @assignment_id = Assignment.where(clinic_id: params[:clinic_id],
                                      doctor_id: params[:doctor_id]).first.id
    respond_to do |format|
      format.js
    end
  end
  
  def hour_options
    hour = Struct.new(:id, :time)
    @hours = []
    if params[:day] != ''
      day = params[:day].to_date
      assignment = Assignment.where(clinic_id: params[:clinic_id], doctor_id: params[:doctor_id]).first
      schedules = Schedule.where(assignment_id: assignment.id, weekday: day.to_date.wday)
      appointments = Appointment.where(assignment_id: assignment.id, day: day)
      if !@appointment.nil?
        appointments -= @appointment
      end
      i = 1
      current = Time.zone.now - Time.zone.now.sec - Time.zone.now.min%30*60 + 30.minutes
      schedules.each do |schedule|
        if day != Date.today
          current = schedule.start_hour
        end
        while current.strftime('%H%M') < schedule.end_hour.strftime('%H%M') do
          if !appointments.any?{|appointment| appointment.hour.strftime('%H%M') == current.strftime('%H%M')}
            @hours << hour.new(i, current)
          end
          i += 1
          current = current + 30.minutes
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
    
    def find_patients
      @appointments.each do |appointment|
        @patients << Patient.find(appointment.patient_id)
      end
    end
    
    def find_doctors
      assignments = []
      @appointments.each do |appointment|
        assignments << Assignment.find(appointment.assignment_id)
      end
      assignments.each do |assignment|
        @doctors << Doctor.find(assignment.doctor_id)
      end
    end

    def appointment_params
      params.require(:appointment).permit(:assignment_id, :day, :hour)
    end
end
