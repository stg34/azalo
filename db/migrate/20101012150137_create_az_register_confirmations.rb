class CreateAzRegisterConfirmations < ActiveRecord::Migration
  def self.up
    create_table :az_register_confirmations do |t|
      t.integer :az_user_id
      t.string :confirm_hash
      t.timestamps
    end
  end

  def self.down
    drop_table :az_register_confirmations
  end
end
