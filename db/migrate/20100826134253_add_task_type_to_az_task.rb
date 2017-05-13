class AddTaskTypeToAzTask < ActiveRecord::Migration
  def self.up
    add_column :az_tasks, :task_type, :integer, :null => false, :default => 0
  end

  def self.down
    remove_column  :az_tasks, :task_type
  end
end
