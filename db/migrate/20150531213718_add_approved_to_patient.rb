class AddApprovedToPatient < ActiveRecord::Migration
  def self.up
    add_column :patients, :approved, :boolean, :default => false, :null => false
    add_index  :patients, :approved
  end

  def self.down
    remove_index  :patients, :approved
    remove_column :patients, :approved
  end
end
