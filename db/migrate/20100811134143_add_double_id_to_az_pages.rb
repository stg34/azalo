class AddDoubleIdToAzPages < ActiveRecord::Migration
  def self.up
    add_column :az_pages, :az_design_double_page_id, :integer
    add_column :az_pages, :az_block_double_page_id, :integer
  end

  def self.down
    remove_column :az_pages, :az_design_double_page_id
    remove_column :az_pages, :az_block_double_page_id
  end
end
