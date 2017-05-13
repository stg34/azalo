class CreateAzOperations < ActiveRecord::Migration
  def self.up

    create_table :az_operations do |t|
      t.string :name, :null=>false
      t.string :crud_name, :null=>false
      t.timestamps
      #t.string :data_type_type
      t.decimal :complexity, :float, :default=>1, :null => false
    end
   
  end

  def self.down
    drop_table :az_operations
  end
end
