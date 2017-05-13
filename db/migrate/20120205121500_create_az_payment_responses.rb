class CreateAzPaymentResponses < ActiveRecord::Migration
  def self.up
    create_table :az_payment_responses do |t|
      t.integer :az_payment_id
      t.string :status
      t.text :response
      t.string :transaction_id
      t.timestamps
    end
    add_index :az_payment_responses, :az_payment_id
    add_index :az_payment_responses, :transaction_id
  end

  def self.down
    drop_table :az_payment_responses
  end
end
