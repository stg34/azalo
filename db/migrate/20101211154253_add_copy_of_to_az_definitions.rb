class AddCopyOfToAzDefinitions < ActiveRecord::Migration
  def self.up
    add_column :az_definitions, :copy_of, :integer
  end

  def self.down
    remove_column  :az_definitions, :copy_of
  end
end
