class CreateAzBalanceTransactions < ActiveRecord::Migration
  def self.up
    create_table :az_balance_transactions do |t|
      t.integer :az_company_id, :null => false
      t.string :description
      t.decimal :amount, :null => false, :scale => 2, :precision => 20
      t.integer :az_invoice_id
      t.timestamps
    end
    add_index :az_balance_transactions, :az_company_id
  end

  def self.down
    drop_table :az_balance_transactions
  end
end
