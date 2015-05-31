class ClinicsController < ApplicationController
  before_action :set_clinic, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @clinics = Clinic.all
    respond_with(@clinics)
  end

  def show
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

  private
    def set_clinic
      @clinic = Clinic.find(params[:id])
    end

    def clinic_params
      params.require(:clinic).permit(:name)
    end
end
