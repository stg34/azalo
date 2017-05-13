class AddProjectIdToStructs < ActiveRecord::Migration
  def self.up
    add_column :az_base_data_types, :az_base_project_id, :integer
  end

  def self.down
    remove_column  :az_base_data_types, :az_base_project_id
  end
end
