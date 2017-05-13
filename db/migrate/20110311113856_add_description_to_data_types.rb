class AddDescriptionToDataTypes < ActiveRecord::Migration
  def self.up
    add_column  :az_base_data_types, :description, :text, :null => false, :default => ''
  end

  def self.down
    remove_column  :az_base_data_types, :description
  end
end
