class RenameProjectIdInPages < ActiveRecord::Migration
  def self.up
    rename_column "az_pages", "project_id", "az_project_id"
  end

  def self.down
    rename_column "az_pages", "az_project_id", "project_id"
  end
end
