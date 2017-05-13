class AddCopyOfToTypedPages < ActiveRecord::Migration
  def self.up
    add_column :az_typed_pages, :copy_of, :integer
    add_index :az_typed_pages, :copy_of
  end

  def self.down
    remove_column :az_typed_pages, :copy_of
  end
end
