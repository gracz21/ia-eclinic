json.array!(@appointments) do |appointment|
  json.extract! appointment, :id, :patient_id, :assignment_id, :day, :hour
  json.url appointment_url(appointment, format: :json)
end
