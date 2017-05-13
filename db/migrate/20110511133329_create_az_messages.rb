class CreateAzMessages < ActiveRecord::Migration
  def self.up
    create_table :az_messages do |t|
      t.integer :message_type
      t.string :email
      t.string :subject
      t.text :message

      t.timestamps
    end
  end

  def self.down
    drop_table :az_messages
  end
end
