class AddCopyOfAzBaseDataType < ActiveRecord::Migration
  def self.up
    add_column :az_base_data_types, :copy_of, :integer
  end

  def self.down
    remove_column  :az_base_data_types, :copy_of
  end
end
