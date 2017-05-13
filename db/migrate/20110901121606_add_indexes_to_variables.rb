class AddIndexesToVariables < ActiveRecord::Migration
  def self.up
    add_index :az_variables, :az_struct_data_type_id
    add_index :az_variables, :copy_of
    add_index :az_variables, :owner_id
  end

  def self.down
    remove_index :az_variables, :az_struct_data_type_id
    remove_index :az_variables, :copy_of
    remove_index :az_variables, :owner_id
  end
end
