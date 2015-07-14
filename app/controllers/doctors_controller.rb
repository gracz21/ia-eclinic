class DoctorsController < ApplicationController
  include ApplicationHelper
  before_action :set_doctor, only: [:show, :edit, :update, :destroy,
    :assign_clinic, :unassign_clinic]
  before_action :is_logged_in
  before_action :is_admin, only: [:show, :new, :edit, :destroy,
    :create, :update, :assign_clinic, :unassign_clinic]

  respond_to :html

  def index
    @doctors = Doctor.all
    respond_with(@doctors)
  end

  def show
    @clinics = Clinic.where.not(id: @doctor.clinic_ids)
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

  private
    def set_doctor
      @doctor = Doctor.find(params[:id])
    end

    def doctor_params
      params.require(:doctor).permit(:first_name, :last_name, :pwz, :email, :password)
    end
end
