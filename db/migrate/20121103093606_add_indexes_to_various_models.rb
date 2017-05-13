class AddIndexesToVariousModels < ActiveRecord::Migration
  def self.up
    add_index :az_variables, :az_base_data_type_id
    add_index :az_base_data_types, :az_base_data_type_id
    add_index :az_validators, :owner_id
    add_index :az_design_sources, :az_design_id
  end

  def self.down
    remove_index :az_variables, :az_base_data_type_id
    remove_index :az_base_data_types, :az_base_data_type_id
    remove_index :az_validators, :owner_id
    remove_index :az_design_sources, :az_design_id
  end
end
