class RenamePageIdInDesigns < ActiveRecord::Migration
  def self.up
    rename_column "designs", "page_id", "az_page_id"
  end

  def self.down
    rename_column "designs", "az_page_id", "page_id"
  end
end
