class CreateAzVariables < ActiveRecord::Migration
  def self.up
    create_table :az_variables do |t|
      t.string :name
      t.integer :az_base_data_type_id
      t.integer :az_struct_data_type_id

      t.timestamps
    end
  end

  def self.down
    drop_table :az_variables
  end
end
