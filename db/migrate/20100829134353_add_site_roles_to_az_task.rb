class AddSiteRolesToAzTask < ActiveRecord::Migration
  def self.up
    add_column :az_tasks, :role_user, :boolean, :default => false, :null => false
    add_column :az_tasks, :role_admin, :boolean, :default => false, :null => false
  end

  def self.down
    remove_column :az_tasks, :role_user
    remove_column :az_tasks, :role_admin
  end
end
