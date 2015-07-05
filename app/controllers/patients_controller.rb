class PatientsController < ApplicationController
  before_action :set_patient, only: [:show, :edit, :update, :destroy, :activate]

  respond_to :html

  def index
    if params[:approved] == "false"
      @patients = Patient.where(approved: false)
    else
      @patients = Patient.all
    end
    respond_with(@patients)
  end

  def show
    respond_with(@patient)
  end

  def new
    @patient = Patient.new
    respond_with(@patient)
  end

  def edit
  end

  def create
    @patient = Patient.new(patient_params)
    @patient.save
    respond_with(@patient)
  end

  def update
    @patient.update(patient_params)
    respond_with(@patient)
  end

  def destroy
    @patient.destroy
    respond_with(@patient)
  end
  
  def activate
    if params[:activate] == "true"
      @patient.approved = true
    else
      @patient.approved = false
    end
    @patient.save
    redirect_to(:back)
  end

  private
    def set_patient
      @patient = Patient.find(params[:id])
    end

    def patient_params
      params.require(:patient).permit(:first_name, :last_name, :pesel, :address)
    end
end
