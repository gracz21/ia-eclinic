class SchedulesController < ApplicationController
  include ApplicationHelper
  include SchedulesHelper
  before_action :is_logged_in
  before_action :set_doc, only: [:index, :show, :new, :edit, 
    :create, :update, :destroy]
  before_action :is_authorized, only: [:index, :show, :new, :edit, :create, :update, :destroy]
  before_action :set_schedule, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @schedules = Schedule.where(assignment_id: @doctor.assignment_ids).order(:weekday, :start_hour)
    @clinic_names = []
    @schedules.each do |schedule|
      @clinic_names << schedule.assignment.clinic.name
    end
    gen_weekday_list
    respond_with(@schedules)
  end

  def show
    @clinic_name = @schedule.assignment.clinic.name
    gen_weekday_list
    respond_with(@schedule)
  end

  def new
    @assignment_id = Assignment.new
    @schedule = Schedule.new
    gen_weekday_list
    respond_with(@schedule)
  end

  def edit
    @assignment_id = @schedule.assignment
    gen_weekday_list
  end
  
  def get_assignment_id_s
    @assignment_id = Assignment.where(clinic_id: params[:clinic_id],
      doctor_id: current_doctor.id).first.id
    respond_to do |format|
      format.js
    end
  end

  def create
    @assignment = Assignment.find(params[:schedule][:assignment_id])
    @schedule = @assignment.schedules.build(schedule_params)
    if @schedule.save
      redirect_to doctor_schedule_url(@doctor, @schedule.id)
    else
      @assignment_id = Assignment.new
      gen_weekday_list
      render :new
    end
  end

  def update
    prev_schedule = @schedule
    if @schedule.update(schedule_params)
      redirect_to doctor_schedule_url(@doctor, @schedule.id)
    else
      @assignment_id = Assignment.find(params[:schedule][:assignment_id])
      gen_weekday_list
      render :edit
    end
  end

  def destroy
    @schedule.destroy
    redirect_to doctor_schedules_url(@doctor)
  end

  private
    def set_doc
      @doctor = Doctor.find(params[:doctor_id])
    end
  
    def set_schedule
      @schedule = Schedule.find(params[:id])
    end

    def schedule_params
      params.require(:schedule).permit(:assignment_id, :weekday, :start_hour, :end_hour)
    end
end
