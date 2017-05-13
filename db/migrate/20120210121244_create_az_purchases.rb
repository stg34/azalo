class CreateAzPurchases < ActiveRecord::Migration
  def self.up
    create_table :az_purchases do |t|
      t.integer :az_company_id,     :null => false
      t.integer :az_store_item_id,  :null => false
      t.integer :az_bill_id,        :null => false

      t.timestamps
    end
    add_index :az_purchases, :az_company_id
    add_index :az_purchases, :az_store_item_id
    add_index :az_purchases, :az_bill_id
  end

  def self.down
    drop_table :az_purchases
  end
end
