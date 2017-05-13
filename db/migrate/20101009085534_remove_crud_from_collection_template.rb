class RemoveCrudFromCollectionTemplate < ActiveRecord::Migration
  def self.up
    remove_column :az_collection_templates, :create_task_time
    remove_column :az_collection_templates, :update_task_time
    remove_column :az_collection_templates, :read_task_time
    remove_column :az_collection_templates, :delete_task_time
  end

  def self.down
    add_column :az_collection_templates, :create_task_time, :float, :default => 0.0
    add_column :az_collection_templates, :update_task_time, :float, :default => 0.0
    add_column :az_collection_templates, :read_task_time, :float, :default => 0.0
    add_column :az_collection_templates, :delete_task_time, :float, :default => 0.0
  end
end
