class SchedulesController < ApplicationController
  include ApplicationHelper
  before_action :set_doc
  before_action :set_schedule, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @schedules = Schedule.where(assignment_id: @doctor.assignment_ids).order(:weekday, :start_hour)
    @clinic_names = []
    @schedules.each do |schedule|
      assignment = Assignment.find(schedule.assignment_id)
      @clinic_names << Clinic.find(assignment.clinic_id).name
    end
    gen_weekday_list
    respond_with(@schedules)
  end

  def show
    respond_with(@schedule)
  end

  def new
    @schedule = Schedule.new
    gen_weekday_list
    respond_with(@schedule)
  end

  def edit
    gen_weekday_list
  end

  def create
    @schedule = Schedule.new(schedule_params)
    if(@schedule.start_hour.strftime('%H%M') >= @schedule.end_hour.strftime('%H%M'))
      redirect_to :back, :notice => "Start hour can't be greater or equal to end hour" and return
    end
    schedules = Schedule.all
    schedules.each do |tmp|
      if tmp.weekday == @schedule.weekday
        if !(@schedule.end_hour.strftime('%H%M') <= tmp.start_hour.strftime('%H%M') or
          @schedule.start_hour.strftime('%H%M') >= tmp.end_hour.strftime('%H%M'))
          redirect_to :back, :notice => "Problem with the start hour or end hour" and return
        end
      end
    end
    @assignment.schedules << @schedule
    @schedule.save
    redirect_to doctor_schedule_url(@doctor, @schedule.id)
  end

  def update
    @schedule.update(schedule_params)
    respond_with(@schedule)
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
      @assignment = Assignment.where(doctor_id: params[:doctor_id],
        clinic_id: params[:schedule][:assignment_id]).first
      params.require(:schedule).permit(@assignment, :weekday, :start_hour, :end_hour)
    end
end
