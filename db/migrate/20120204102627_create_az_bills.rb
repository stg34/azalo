class CreateAzBills < ActiveRecord::Migration
  def self.up
    create_table :az_bills do |t|
      t.integer :az_invoice_id, :null=>false
      t.text :description
      t.datetime :date_from
      t.datetime :date_till
      t.decimal :fee, :null => false, :scale => 2, :precision => 20
      t.timestamps
    end

    add_index :az_bills, :az_invoice_id
    add_index :az_bills, :date_from
    add_index :az_bills, :date_till

  end

  def self.down
    drop_table :az_bills
  end
end
