class RemoveCrudTimesFromBaseDataType < ActiveRecord::Migration
  def self.up
    remove_column :az_base_data_types, :create_task_time
    remove_column :az_base_data_types, :update_task_time
    remove_column :az_base_data_types, :read_task_time
    remove_column :az_base_data_types, :delete_task_time
  end

  def self.down
    add_column :az_base_data_types, :create_task_time, :float, :default => 0.0
    add_column :az_base_data_types, :update_task_time, :float, :default => 0.0
    add_column :az_base_data_types, :read_task_time, :float, :default => 0.0
    add_column :az_base_data_types, :delete_task_time, :float, :default => 0.0
  end
end
