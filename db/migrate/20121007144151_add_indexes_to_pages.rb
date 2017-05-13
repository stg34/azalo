class AddIndexesToPages < ActiveRecord::Migration
  def self.up
    add_index :az_pages, :az_functionality_double_page_id
    add_index :az_pages, :az_design_double_page_id
  end

  def self.down
    remove_index :az_pages, :az_functionality_double_page_id
    remove_index :az_pages, :az_design_double_page_id
  end
end
