json.array!(@patients) do |patient|
  json.extract! patient, :id, :first_name, :last_name, :pesel, :address
  json.url patient_url(patient, format: :json)
end
