class RemoveRmRoleIdFromAzTask < ActiveRecord::Migration
  def self.up
    remove_column :az_tasks, :rm_role_id
  end

  def self.down
  end
end
