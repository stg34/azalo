class RenameFunctionalityDoubleColumnInAzPage < ActiveRecord::Migration
  def self.up
    rename_column :az_pages, :az_block_double_page_id, :az_functionality_double_page_id
  end

  def self.down
    rename_column :az_pages, :az_functionality_double_page_id, :az_block_double_page_id
  end
end
