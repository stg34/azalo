class CreateAzMailings < ActiveRecord::Migration
  def self.up
    create_table "az_mailings" do |t|
      t.integer  :az_mailing_message_id,        :null => false
      t.text     :comment,                      :null => false
      t.boolean  :active,                       :null => false, :default => false
      t.integer  :status,                       :null => false, :default => 1
      t.datetime :created
    end
  end

  def self.down
    drop_table "az_mailings"
  end
end
