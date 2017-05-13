class MergeUserAndAdminTimeOperationsInTemplates < ActiveRecord::Migration
  def self.up
    remove_column :az_collection_templates,  :create_admin_task_time
    remove_column :az_collection_templates,  :read_admin_task_time
    remove_column :az_collection_templates,  :update_admin_task_time
    remove_column :az_collection_templates,  :delete_admin_task_time

    rename_column :az_collection_templates, :create_user_task_time, :create_task_time
    rename_column :az_collection_templates, :read_user_task_time,   :read_task_time
    rename_column :az_collection_templates, :update_user_task_time, :update_task_time
    rename_column :az_collection_templates, :delete_user_task_time, :delete_task_time
  end

  def self.down
    rename_column :az_collection_templates, :create_task_time, :create_user_task_time
    rename_column :az_collection_templates, :read_task_time,   :read_user_task_time
    rename_column :az_collection_templates, :update_task_time, :update_user_task_time
    rename_column :az_collection_templates, :delete_task_time, :delete_user_task_time

    add_column :az_collection_templates,  :create_admin_task_time, :float, :default => 0.0
    add_column :az_collection_templates,  :read_admin_task_time, :float, :default => 0.0
    add_column :az_collection_templates,  :update_admin_task_time, :float, :default => 0.0
    add_column :az_collection_templates,  :delete_admin_task_time, :float, :default => 0.0

    execute('update az_collection_templates set create_admin_task_time=create_user_task_time')
    execute('update az_collection_templates set read_admin_task_time=read_user_task_time')
    execute('update az_collection_templates set update_admin_task_time=update_user_task_time')
    execute('update az_collection_templates set delete_admin_task_time=delete_user_task_time')
  end
end
