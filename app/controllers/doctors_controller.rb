class DoctorsController < ApplicationController
  include ApplicationHelper
  include SchedulesHelper
  include AppointmentsHelper
  before_action :set_doctor, only: [:show, :edit, :update, :destroy,
    :assign_clinic, :unassign_clinic]
  before_action :is_logged_in
  before_action :is_admin, only: [:new, :edit, :destroy,
    :create, :update, :assign_clinic, :unassign_clinic]

  respond_to :html

  def index
    @doctors = Doctor.all
    respond_with(@doctors)
  end

  def show
    @clinics = Clinic.all - @doctor.clinics
    @schedules = Schedule.where(assignment_id: @doctor.assignment_ids).order(:weekday, :start_hour)
    @clinic_names = []
    @schedules.each do |schedule|
      @clinic_names << schedule.assignment.clinic.name
    end
    gen_weekday_list
    respond_with(@doctor)
  end

  def new
    @doctor = Doctor.new
    respond_with(@doctor)
  end

  def edit
  end

  def create
    @doctor = Doctor.new(doctor_params)
    @doctor.save
    respond_with(@doctor)
  end

  def update
    @doctor.update(doctor_params)
    respond_with(@doctor)
  end

  def destroy
    @doctor.destroy
    respond_with(@doctor)
  end
  
  def assign_clinic
    clinic = Clinic.find(params[:doctor][:clinics])
    @doctor.clinics << clinic
    @doctor.save
    respond_with(@doctor)
  end
  
  def unassign_clinic
    @doctor.clinics.destroy(params[:doctor][:clinics])
    @doctor.save
    respond_with(@doctor)
  end
  
  def doctor_get_free_appointments
    @hours = []
    @doctors = []
    if params[:day] != ''
      day = params[:day].to_date
      doctor = Doctor.find(params[:doctor_id])
      schedules = []
      appointments = []
      doctor.assignments.each do |assignment|
        schedules += assignment.schedules.where(weekday: day.wday)
        appointments += assignment.appointments.where(day: day)
      end
      @clinic_names = []
      gen_free_hours(day, schedules, appointments)
      @hours.each do |hour|
        @clinic_names << Assignment.find(hour.assignment_id).clinic.name
      end
    end
    respond_to do |format|
      format.js
    end
  end

  private
    def set_doctor
      @doctor = Doctor.find(params[:id])
    end

    def doctor_params
      params.require(:doctor).permit(:first_name, :last_name, :pwz, :email, :password)
    end
end
