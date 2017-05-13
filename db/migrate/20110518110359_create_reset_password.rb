class CreateResetPassword < ActiveRecord::Migration
  def self.up
    create_table :az_reset_passwords do |t|
      t.string :hash_str, :null => false
      t.integer :az_user_id, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :az_reset_passwords
  end
end
