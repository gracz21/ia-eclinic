class AddConfirmedToAppointment < ActiveRecord::Migration
  def change
    change_table :appointments do |t|
      t.boolean :confirmed, default: false, null: false
    end
  end
end
