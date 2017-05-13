class AddTaskTimeToAzCollections < ActiveRecord::Migration
  def self.up
    add_column :az_collection_templates, :create_user_task_time, :float, :default => 0.0
    add_column :az_collection_templates, :read_user_task_time,   :float, :default => 0.0
    add_column :az_collection_templates, :update_user_task_time, :float, :default => 0.0
    add_column :az_collection_templates, :delete_user_task_time, :float, :default => 0.0

    add_column :az_collection_templates, :create_admin_task_time, :float, :default => 0.0
    add_column :az_collection_templates, :read_admin_task_time,   :float, :default => 0.0
    add_column :az_collection_templates, :update_admin_task_time, :float, :default => 0.0
    add_column :az_collection_templates, :delete_admin_task_time, :float, :default => 0.0
  end

  def self.down
    remove_column :az_collection_templates, :create_user_task_time
    remove_column :az_collection_templates, :read_user_task_time
    remove_column :az_collection_templates, :update_user_task_time
    remove_column :az_collection_templates, :delete_user_task_time

    remove_column :az_collection_templates, :create_admin_task_time
    remove_column :az_collection_templates, :read_admin_task_time
    remove_column :az_collection_templates, :update_admin_task_time
    remove_column :az_collection_templates, :delete_admin_task_time
  end
end
