class AddOwnerIdIndexToBaseDataTypes < ActiveRecord::Migration
  def self.up
    add_index :az_base_data_types, :owner_id
  end

  def self.down
    remove_index :az_base_data_types, :owner_id
  end
end
