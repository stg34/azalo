class AddTypeToProjects < ActiveRecord::Migration
  def self.up
    add_column :az_base_projects,  :type,  :string
    AzProject.update_all("type = 'AzProject'")
  end

  def self.down
    remove_column :az_base_projects,  :type
  end
end
