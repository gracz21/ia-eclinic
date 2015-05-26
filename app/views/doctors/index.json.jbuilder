json.array!(@doctors) do |doctor|
  json.extract! doctor, :id, :first_name, :last_name, :pwz
  json.url doctor_url(doctor, format: :json)
end
