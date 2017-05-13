class CreateAzStoreItemScetches < ActiveRecord::Migration
  def self.up
    create_table :az_store_item_scetches do |t|
      t.string    :scetch_file_name,     :null => false
      t.string    :scetch_content_type,  :null => false
      t.integer   :scetch_file_size,     :null => false
      t.datetime  :scetch_updated_at,    :null => false
      t.integer :az_store_item_id
      t.string :alt,   :null => false
      t.string :title, :null => false

      t.timestamps
    end
    add_index :az_store_item_scetches, :az_store_item_id
  end

  def self.down
    drop_table :az_store_item_scetches
  end
end
