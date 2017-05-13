class CreateAzTrTexts < ActiveRecord::Migration
  def self.up
    create_table :az_tr_texts do |t|
      t.string :name, :null => false
      t.integer :owner_id, :null => false
      t.integer :az_operation_id
      t.integer :data_type
      t.text :text
      t.integer :copy_of
      t.timestamps
    end

    add_index :az_tr_texts, :owner_id
  end

  def self.down
    drop_table :az_tr_texts
  end
end
