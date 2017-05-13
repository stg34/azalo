class AddCopyOfToAzTasks < ActiveRecord::Migration
  def self.up
    add_column :az_tasks, :copy_of, :integer
  end

  def self.down
    remove_column  :az_tasks, :copy_of
  end
end
