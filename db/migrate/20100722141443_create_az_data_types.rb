class CreateAzDataTypes < ActiveRecord::Migration
  def self.up
    create_table :az_data_types do |t|
      t.string :name
      t.boolean :array
      t.timestamps
    end
  end

  def self.down
    drop_table :az_data_types
  end
end
