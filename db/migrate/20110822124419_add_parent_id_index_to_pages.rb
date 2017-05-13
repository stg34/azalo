class AddParentIdIndexToPages < ActiveRecord::Migration
  def self.up
    add_index :az_pages, :parent_id
  end

  def self.down
    remove_index :az_pages, :parent_id
  end
end
