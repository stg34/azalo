class AddPublicAccessToProjects < ActiveRecord::Migration
  def self.up
    add_column  :az_base_projects, :public_access, :boolean
  end

  def self.down
    remove_column  :az_base_projects, :public_access
  end
end
