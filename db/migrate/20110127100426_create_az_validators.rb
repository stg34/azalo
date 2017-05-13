class CreateAzValidators < ActiveRecord::Migration
  def self.up
    create_table :az_validators do |t|
      t.integer :owner_id, :null => false
      t.integer :az_variable_id
      t.string :name, :null => false
      t.text :description, :null => false
      t.text :condition
      t.text :message, :null => false
      t.integer :position
      t.integer :copy_of
      t.boolean :seed

      t.timestamps
    end
  end

  def self.down
    drop_table :az_validators
  end
end
