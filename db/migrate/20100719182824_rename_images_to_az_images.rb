class RenameImagesToAzImages < ActiveRecord::Migration
  def self.up
    rename_table "images", "az_images"
  end

  def self.down
    rename_table "az_images", "images"
  end
end
