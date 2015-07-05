class CreateClinicsDoctors < ActiveRecord::Migration
  def change
    create_table :clinics_doctors do |t|
      t.integer :clinic_id
      t.integer :doctor_id
    end
    add_index :clinics_doctors, [:clinic_id, :doctor_id]
  end
end
