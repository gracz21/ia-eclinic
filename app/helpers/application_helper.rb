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
  
  def gen_weekday_list
    weekday = Struct.new(:id, :name)
    @weekday_list = [weekday.new(1, 'Monday'), 
      weekday.new(2, 'Tuesday'), 
      weekday.new(3, 'Wednesday'), 
      weekday.new(4, 'Thursday'), 
      weekday.new(5, 'Friday')]
  end
end
