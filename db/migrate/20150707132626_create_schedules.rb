class CreateSchedules < ActiveRecord::Migration
  def change
    create_table :schedules do |t|
      t.belongs_to :assignment, index: true
      t.integer :weekday
      t.time :start_hour
      t.time :end_hour

      t.timestamps null: false
    end
  end
end
