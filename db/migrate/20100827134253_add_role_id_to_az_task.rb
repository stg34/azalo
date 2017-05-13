class AddRoleIdToAzTask < ActiveRecord::Migration
  def self.up
    add_column :az_tasks, :az_rm_role_id, :integer
    remove_column :az_tasks, :az_role_id
    remove_column :az_tasks, :az_base_data_type_id
  end

  def self.down
    remove_column :az_tasks, :az_rm_role_id
    add_column :az_tasks, :az_role_id, :integer
    add_column :az_tasks, :az_base_data_type_id, :integer
  end
end
