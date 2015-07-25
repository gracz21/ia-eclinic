module AppointmentsHelper
  def gen_free_hours(day, schedules, appointments)
    hour = Struct.new(:time, :assignment_id)
    @hours = []
    schedules.each do |schedule|
      current = schedule.start_hour
      if day == Date.today
        if current.strftime('%H%M') < Time.zone.now.strftime('%H%M')
          current = Time.zone.now - Time.zone.now.sec - Time.zone.now.min%30*60 + 30.minutes
        end
      end
      while current.strftime('%H%M') < schedule.end_hour.strftime('%H%M') do
        if !appointments.select{ |tmp| tmp.assignment_id == schedule.assignment_id }.any?{|appointment| appointment.hour.strftime('%H%M') == current.strftime('%H%M')}
          @hours << hour.new(current, schedule.assignment_id)
        end
        current = current + 30.minutes
      end
    end
  end
    
  def gen_free_hours_for_doctor(doctor, assignment_ids)
    schedules = []
    if assignment_ids.nil?
      doctor.assignments.each do |assignment|
        schedules += assignment.schedules
      end
    else
      doctor.assignments.where(id: assignment_ids).each do |assignment|
        schedules += assignment.schedules
      end
    end
    current_day = Date.today
    free_hours = []
    while free_hours.size == 0 do
      appointments = []
      doctor.assignments.each do |assignment|
        appointments += assignment.appointments
      end
      gen_free_hours(current_day, schedules.select { |tmp| tmp.weekday == current_day.wday }, appointments)
      free_hours += @hours
      current_day += 1.day
    end
    free_hours.sort_by! { |tmp| tmp.time }
    @hour = free_hours.first.time
    @day = current_day - 1.day
    @assignment_id = free_hours.first.assignment_id
  end
    
  def gen_free_hours_for_clinic(clinic)
    free_hours = []
    first_appointment = Struct.new(:hour, :day, :assignment_id)
    clinic.doctors.each do |doctor|
      gen_free_hours_for_doctor(doctor, clinic.assignments)
      free_hours << first_appointment.new(@hour, @day, @assignment_id)
    end
    free_hours.sort_by! { |tmp| [tmp.day, tmp.hour] }
    @appointment_data = free_hours.first
  end
  
  def is_authorized_patient
    if current_patient
      if @appointment.patient != current_patient
        redirect_to root_url, notice: "You are not allowed to do that!" and return
      end
    end
  end
  
  def is_authorized_doctor
    if current_doctor
      if @appointment.assignment.doctor != current_doctor
        redirect_to root_url, notice: "You are not allowed to do that!" and return
      end
    end
  end
end
