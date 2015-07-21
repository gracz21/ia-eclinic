class AddIndexToAssignmentsTable < ActiveRecord::Migration
  def change
    add_index :assignments, [:clinic_id, :doctor_id], unique: true
  end
end
