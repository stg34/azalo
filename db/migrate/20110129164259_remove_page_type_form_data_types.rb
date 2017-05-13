class RemovePageTypeFormDataTypes < ActiveRecord::Migration
  def self.up
    remove_column :az_base_data_types, :is_page_type
    remove_column :az_base_data_types, :is_assignable_page_type
  end

  def self.down
  end
end
