class AddStatusToTables < ActiveRecord::Migration
  def self.up
    add_column  :az_base_data_types, :status, :integer, :null => false, :default => 0
    add_column  :az_definitions,     :status, :integer, :null => false, :default => 0
    add_column  :az_commons,         :status, :integer, :null => false, :default => 0
    add_column  :az_pages,           :status, :integer, :null => false, :default => 0
  end

  def self.down
    remove_column  :az_base_data_types, :status
    remove_column  :az_definitions, :status
    remove_column  :az_commons, :status
    remove_column  :az_pages, :status
  end
end
