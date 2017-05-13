class AddTaskTimeToAzBaseDataType < ActiveRecord::Migration
  def self.up
    add_column :az_base_data_types, :create_user_task_time, :float, :default => 0.0
    add_column :az_base_data_types, :read_user_task_time,   :float, :default => 0.0
    add_column :az_base_data_types, :update_user_task_time, :float, :default => 0.0
    add_column :az_base_data_types, :delete_user_task_time, :float, :default => 0.0

    add_column :az_base_data_types, :create_admin_task_time, :float, :default => 0.0
    add_column :az_base_data_types, :read_admin_task_time,   :float, :default => 0.0
    add_column :az_base_data_types, :update_admin_task_time, :float, :default => 0.0
    add_column :az_base_data_types, :delete_admin_task_time, :float, :default => 0.0
  end

  def self.down
    remove_column :az_base_data_types, :create_user_task_time
    remove_column :az_base_data_types, :read_user_task_time
    remove_column :az_base_data_types, :update_user_task_time
    remove_column :az_base_data_types, :delete_user_task_time

    remove_column :az_base_data_types, :create_admin_task_time
    remove_column :az_base_data_types, :read_admin_task_time
    remove_column :az_base_data_types, :update_admin_task_time
    remove_column :az_base_data_types, :delete_admin_task_time
  end
end
