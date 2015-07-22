class AppointmentsController < ApplicationController
  include ApplicationHelper
  before_action :is_logged_in
  before_action :set_appointment, only: [:show, :edit, :update, :confirm_appointment,
    :destroy]

  respond_to :html

  def index
    @patients = []
    @doctors = []
    @clinics = []
    if current_patient
      @appointments = current_patient.appointments
      find_doctors
    end
    if current_doctor
      @appointments = Appointment.where(assignment_id: current_doctor.assignment_ids,
        confirmed: true)
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
    respond_with(@appointment)
  end

  def new
    @appointment = Appointment.new
    @clinics = []
    Clinic.all.each do |clinic|
      if clinic.assignments.size > 0
        @clinics << clinic
      end
    end
    @doctors = []
    @hours = []
    respond_with(@appointment)
  end

  def edit
  end

  def create
    @appointment = current_patient.appointments.build(appointment_params)
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
    if params[:day] != ''
      day = params[:day].to_date
      assignment = Assignment.where(clinic_id: params[:clinic_id], doctor_id: params[:doctor_id]).first
      schedules = Schedule.where(assignment_id: assignment.id, weekday: day.wday)
      appointments = Appointment.where(assignment_id: assignment.id, day: day)
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
    respond_with(@appointment)
  end
  
  def first_free_doctor
    gen_free_hours_for_doctor(Doctor.find(params[:doctor_id]), nil)
    @appointment = current_patient.appointments.build(assignment_id: @assignment_id,
                                                      hour: @hour, day: @day)
    @appointment.save
    respond_with(@appointment)
  end
  
  def confirm_appointment
    @appointment.confirmed = true
    @appointment.save
    redirect_to(:back)
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
    
    def gen_free_hours(day, schedules, appointments)
      hour = Struct.new(:time, :assignment_id)
      @hours = []
      schedules.each do |schedule|
        if day != Date.today
          current = schedule.start_hour
        else
          current = Time.zone.now - Time.zone.now.sec - Time.zone.now.min%30*60 + 30.minutes
        end
        while current.strftime('%H%M') < schedule.end_hour.strftime('%H%M') do
          if !appointments.select{ |tmp| tmp.assignment_id == schedule.assignment_id }.any?{|appointment| appointment.hour.strftime('%H%M') == current.strftime('%H%M')}
            @hours << hour.new(current, schedule.assignment_id)
          end
          current = current + 30.minutes
        end
      end
    end
    
    def gen_free_hours_for_doctor(doctor, assignment_ids)
      schedules = []
      if assignment_ids.nil?
        doctor.assignments.each do |assignment|
          schedules += assignment.schedules
        end
      else
        doctor.assignments.where(id: assignment_ids).each do |assignment|
          schedules += assignment.schedules
        end
      end
      current_day = Date.today
      free_hours = []
      while free_hours.size == 0 do
        appointments = []
        doctor.assignments.each do |assignment|
          appointments += assignment.appointments
        end
        gen_free_hours(current_day, schedules.select { |tmp| tmp.weekday == current_day.wday }, appointments)
        free_hours += @hours
        current_day += 1.day
      end
      free_hours.sort_by! { |tmp| tmp.time }
      @hour = free_hours.first.time
      @day = current_day - 1.day
      @assignment_id = free_hours.first.assignment_id
    end
    
    def gen_free_hours_for_clinic(clinic)
      free_hours = []
      first_appointment = Struct.new(:hour, :day, :assignment_id)
      clinic.doctors.each do |doctor|
        gen_free_hours_for_doctor(doctor, clinic.assignments)
        free_hours << first_appointment.new(@hour, @day, @assignment_id)
      end
      free_hours.sort_by! { |tmp| [tmp.day, tmp.hour] }
      @appointment_data = free_hours.first
    end
end
