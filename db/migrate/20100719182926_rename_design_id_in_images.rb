class RenameDesignIdInImages < ActiveRecord::Migration
  def self.up
    rename_column "az_images", "design_id", "az_design_id"
  end

  def self.down
    rename_column "az_images", "az_design_id", "design_id"
  end
end
