class MergeUserAndAdminOperationTimes < ActiveRecord::Migration
  def self.up
    remove_column :az_base_data_types,  :create_admin_task_time
    remove_column :az_base_data_types,  :read_admin_task_time
    remove_column :az_base_data_types,  :update_admin_task_time
    remove_column :az_base_data_types,  :delete_admin_task_time

    rename_column :az_base_data_types, :create_user_task_time, :create_task_time
    rename_column :az_base_data_types, :read_user_task_time,   :read_task_time
    rename_column :az_base_data_types, :update_user_task_time, :update_task_time
    rename_column :az_base_data_types, :delete_user_task_time, :delete_task_time
  end

  def self.down
    rename_column :az_base_data_types, :create_task_time, :create_user_task_time
    rename_column :az_base_data_types, :read_task_time,   :read_user_task_time
    rename_column :az_base_data_types, :update_task_time, :update_user_task_time
    rename_column :az_base_data_types, :delete_task_time, :delete_user_task_time

    add_column :az_base_data_types,  :create_admin_task_time, :float, :default => 0.0
    add_column :az_base_data_types,  :read_admin_task_time, :float, :default => 0.0
    add_column :az_base_data_types,  :update_admin_task_time, :float, :default => 0.0
    add_column :az_base_data_types,  :delete_admin_task_time, :float, :default => 0.0
    
    execute('update az_base_data_types set create_admin_task_time=create_user_task_time')
    execute('update az_base_data_types set read_admin_task_time=read_user_task_time')
    execute('update az_base_data_types set update_admin_task_time=update_user_task_time')
    execute('update az_base_data_types set delete_admin_task_time=delete_user_task_time')
  end
end
