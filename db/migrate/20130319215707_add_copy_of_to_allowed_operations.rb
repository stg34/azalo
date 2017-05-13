class AddCopyOfToAllowedOperations < ActiveRecord::Migration
  def self.up
    add_column :az_allowed_operations, :copy_of, :integer
    add_index :az_allowed_operations, :copy_of
  end

  def self.down
    remove_column :az_allowed_operations, :copy_of
  end
end
