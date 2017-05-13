class AddIndexesToTypedPages < ActiveRecord::Migration
  def self.up
    add_index :az_typed_pages, :az_page_id
    add_index :az_typed_pages, :az_base_data_type_id
    add_index :az_typed_pages, :owner_id
  end

  def self.down
    remove_index :az_typed_pages, :az_page_id
    remove_index :az_typed_pages, :az_base_data_type_id
    remove_index :az_typed_pages, :owner_id
  end
end
