json.array!(@schedules) do |schedule|
  json.extract! schedule, :id, :assignment_id, :weekday, :start_hour, :end_hour
  json.url schedule_url(schedule, format: :json)
end
