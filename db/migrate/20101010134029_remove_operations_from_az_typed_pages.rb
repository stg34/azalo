class RemoveOperationsFromAzTypedPages < ActiveRecord::Migration
  def self.up
    remove_column :az_typed_pages, :operation_create
    remove_column :az_typed_pages, :operation_read
    remove_column :az_typed_pages, :operation_update
    remove_column :az_typed_pages, :operation_delete
  end

  def self.down
    add_column :az_typed_pages, :operation_create, :integer, :default => 0
    add_column :az_typed_pages, :operation_read,   :integer, :default => 0
    add_column :az_typed_pages, :operation_update, :integer, :default => 0
    add_column :az_typed_pages, :operation_delete, :integer, :default => 0
  end
end
