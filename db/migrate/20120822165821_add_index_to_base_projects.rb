class AddIndexToBaseProjects < ActiveRecord::Migration
  def self.up
    add_index :az_base_projects, :owner_id
    add_index :az_base_projects, :parent_project_id
  end

  def self.down
    remove_index :az_base_projects, :parent_project_id
    remove_index :az_base_projects, :owner_id
  end
end
