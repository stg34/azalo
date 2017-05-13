class RemoveFieldsFromTariff < ActiveRecord::Migration
  def self.up
    remove_column  :az_tariffs, :quota_components
    remove_column  :az_tariffs, :quota_commons
    remove_column  :az_tariffs, :quota_structures
  end

  def self.down
    add_column  :az_tariffs, :quota_components, :null => false, :default => 0
    add_column  :az_tariffs, :quota_commons,    :null => false, :default => 0
    add_column  :az_tariffs, :quota_structures, :null => false, :default => 0
  end
end
