class AddStatusIdToProject < ActiveRecord::Migration
  def self.up
    status = AzProjectStatus.find(:first)
    add_column :az_base_projects, :az_project_status_id, :integer, :null => false, :default => status.id
  end

  def self.down
    remove_column :az_base_projects, :az_project_status_id
  end
end
