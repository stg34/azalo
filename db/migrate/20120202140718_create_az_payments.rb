class CreateAzPayments < ActiveRecord::Migration
  def self.up
    create_table :az_payments do |t|
      t.integer :az_company_id
      t.decimal :amount, :null => false, :scale => 2, :precision => 20
      #t.string :transaction_id
      t.boolean :started, :default => false, :null => false
      #t.text :response

      t.timestamps
    end
    add_index :az_payments, :az_company_id
    add_index :az_payments, :az_company_id
  end

  def self.down
    drop_table :az_payments
  end
end
