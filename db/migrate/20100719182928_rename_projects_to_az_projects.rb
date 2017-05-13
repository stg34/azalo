class RenameProjectsToAzProjects < ActiveRecord::Migration
  def self.up
    rename_table "projects", "az_projects"
  end

  def self.down
    rename_table "az_projects", "projects"
  end
end
