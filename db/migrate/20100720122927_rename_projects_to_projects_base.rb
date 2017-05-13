class RenameProjectsToProjectsBase < ActiveRecord::Migration
  def self.up
    #rename_column "az_pages", "az_project_id", "az_base_project_id"
    rename_table "az_projects", "az_base_projects"
  end

  def self.down
    #rename_column "az_pages", "az_base_project_id", "az_project_id"
    rename_table "az_base_projects", "az_projects"
  end
end
