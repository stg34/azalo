class RenamePagesToAzPages < ActiveRecord::Migration
  def self.up
    rename_table "pages", "az_pages"
  end

  def self.down
    rename_table "az_pages", "pages"
  end
end
