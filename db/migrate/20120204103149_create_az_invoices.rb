class CreateAzInvoices < ActiveRecord::Migration
  def self.up
    create_table :az_invoices do |t|
      t.integer :az_balance_transaction_id
      t.text :description
      t.timestamps
    end
    add_index :az_invoices, :az_balance_transaction_id, :unique => true
  end

  def self.down
    drop_table :az_invoices
  end
end
