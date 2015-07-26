module SchedulesHelper
  def gen_weekday_list
    weekday = Struct.new(:id, :name)
    @weekday_list = [weekday.new(1, 'Monday'), 
      weekday.new(2, 'Tuesday'), 
      weekday.new(3, 'Wednesday'), 
      weekday.new(4, 'Thursday'), 
      weekday.new(5, 'Friday')]
  end
  
  def is_authorized
    if current_admin
      return
    end
    if current_patient
      redirect_to root_url, notice: "You are not allowed to do that!" and return
    end
    if current_doctor.id.to_s != params[:doctor_id]
      redirect_to root_url, notice: "You are not allowed to do that!"
    end
  end
end
