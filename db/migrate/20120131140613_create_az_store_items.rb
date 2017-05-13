class CreateAzStoreItems < ActiveRecord::Migration
  def self.up
    create_table :az_store_items do |t|
      t.string :item_type
      t.integer :item_id
      t.float :price
      t.boolean :visible

      t.timestamps
    end
  end

  def self.down
    drop_table :az_store_items
  end
end
