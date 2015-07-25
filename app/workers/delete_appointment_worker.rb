class DeleteAppointmentWorker
  include Sidekiq::Worker
  def perform(appointment_id)
    appointment = Appointment.find_by_id(appointment_id)
    if appointment
      if appointment.confirmed == false
        appointment.destroy
      end
    end
  end
end