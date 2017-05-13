class AddProjectIdIndexToBaseDataTypes < ActiveRecord::Migration
  def self.up
    add_index :az_base_data_types, :az_base_project_id
  end

  def self.down
    remove_index :az_base_data_types, :az_base_project_id
  end
end
