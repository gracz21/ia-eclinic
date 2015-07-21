class AddIndexToAppointmentsTable < ActiveRecord::Migration
  def change
    add_index :appointments, [:assignment_id, :hour, :day], unique: true
  end
end
