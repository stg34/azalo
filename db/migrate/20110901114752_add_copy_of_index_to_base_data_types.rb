class AddCopyOfIndexToBaseDataTypes < ActiveRecord::Migration
  def self.up
    add_index :az_base_data_types, :copy_of
  end

  def self.down
    remove_index :az_base_data_types, :copy_of
  end
end
