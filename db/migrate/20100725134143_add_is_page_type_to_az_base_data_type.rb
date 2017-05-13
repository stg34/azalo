class AddIsPageTypeToAzBaseDataType < ActiveRecord::Migration
  def self.up
    add_column :az_base_data_types, :is_page_type, :boolean
  end

  def self.down
    remove_column :az_base_data_types, :is_page_type
  end
end
