class AddRoleCommonToTask < ActiveRecord::Migration
  def self.up
    add_column :az_tasks, :role_common, :boolean, :default => false, :null => false
  end

  def self.down
    remove_column :az_tasks, :role_common
  end
end
