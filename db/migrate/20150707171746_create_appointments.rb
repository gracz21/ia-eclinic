class CreateAppointments < ActiveRecord::Migration
  def change
    create_table :appointments do |t|
      t.belongs_to :patient, index: true
      t.belongs_to :assignment, index: true
      t.date :day
      t.time :hour

      t.timestamps null: false
    end
  end
end
