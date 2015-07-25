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
    if current_doctor.id.to_s != params[:doctor_id]
      redirect_to root_url, notice: "You are not allowed to do that!"
    end
  end
  
  #TODOOOOO
  def appointments_update(delete)
    appointments = @schedule.assignment.appointments.where('day > ?', Date.today)
    appointments = appointments.select{ |appointment| appointment.day.wday == @schedule.weekday }
    if delete == true
      appointments.each do |appointment|
        appointment.destroy
      end
    else
      appointments.each do |appointment|
        if appointment.hour < @schedule.start_hour or appointment.hour >= @schedule.end_hour
          appointment.destroy
        end
      end
    end
  end
end
