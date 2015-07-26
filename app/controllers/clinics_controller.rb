class ClinicsController < ApplicationController
  include ApplicationHelper
  include AppointmentsHelper
  before_action :set_clinic, only: [:show, :edit, :update, :destroy]
  before_action :is_logged_in
  before_action :is_admin, only: [:new, :create, :edit, :update, :destroy]

  respond_to :html

  def index
    @clinics = Clinic.all
    respond_with(@clinics)
  end

  def show
    @doctors = @clinic.doctors
    respond_with(@clinic)
  end

  def new
    @clinic = Clinic.new
    respond_with(@clinic)
  end

  def edit
  end

  def create
    @clinic = Clinic.new(clinic_params)
    @clinic.save
    respond_with(@clinic)
  end

  def update
    @clinic.update(clinic_params)
    respond_with(@clinic)
  end

  def destroy
    @clinic.destroy
    respond_with(@clinic)
  end

  def clinic_get_free_appointments
    @hours = []
    @clinic_names = []
    @doctors = []
    if params[:day] != ''
      day = params[:day].to_date
      clinic = Clinic.find(params[:clinic_id])
      schedules = []
      appointments = []
      clinic.assignments.each do |assignment|
        schedules += assignment.schedules.where(weekday: day.wday)
        appointments += assignment.appointments.where(day: day)
      end
      gen_free_hours(day, schedules, appointments)
      @hours.sort_by! { |hour| [hour.time] }
      @hours.each do |hour|
        @doctors << Assignment.find(hour.assignment_id).doctor
      end
    end
    respond_to do |format|
      format.js
    end
  end

  private
    def set_clinic
      @clinic = Clinic.find(params[:id])
    end

    def clinic_params
      params.require(:clinic).permit(:name)
    end
end
