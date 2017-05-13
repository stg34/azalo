class AddProjectIdIndexToPages < ActiveRecord::Migration
  def self.up
    add_index :az_pages, :az_base_project_id
  end

  def self.down
    remove_index :az_pages, :az_base_project_id
  end
end
