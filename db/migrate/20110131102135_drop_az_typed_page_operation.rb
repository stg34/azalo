class DropAzTypedPageOperation < ActiveRecord::Migration
  def self.up
    drop_table "az_typed_page_operations"
  end

  def self.down
  end
end
