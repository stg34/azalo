class AddRmRoleIdToAzTasks < ActiveRecord::Migration
  def self.up
    add_column :az_tasks, :rm_role_id, :integer
  end

  def self.down
    remove_column :az_tasks, :rm_role_id
  end
end
