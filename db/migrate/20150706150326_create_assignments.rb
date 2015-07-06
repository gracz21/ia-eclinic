class CreateAssignments < ActiveRecord::Migration
  def change
    create_table :assignments do |t|
      t.belongs_to :clinic, index: true
      t.belongs_to :doctor, index: true

      t.timestamps null: false
    end
  end
end
