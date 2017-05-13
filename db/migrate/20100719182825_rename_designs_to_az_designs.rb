class RenameDesignsToAzDesigns < ActiveRecord::Migration
  def self.up
    rename_table "designs", "az_designs"
  end

  def self.down
    rename_table "az_designs", "designs"
  end
end
