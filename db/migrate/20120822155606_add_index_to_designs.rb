class AddIndexToDesigns < ActiveRecord::Migration
  def self.up
    add_index :az_designs, :az_page_id
  end

  def self.down
    remove_index :az_designs, :az_page_id
  end
end
