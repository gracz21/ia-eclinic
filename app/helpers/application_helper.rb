module ApplicationHelper
  def is_admin
    redirect_to root_url, notice: "You are not allowed to do that!" unless current_admin
  end
  
  def is_not_patient
    redirect_to root_url, notice: "You are not allowed to do that!" unless !current_patient
  end
  
  def is_logged_in
    redirect_to root_url, notice: "You have to log in to view this page!" unless patient_signed_in? or doctor_signed_in? or admin_signed_in?
  end
end
