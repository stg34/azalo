class CreateAzOutboxes < ActiveRecord::Migration
  def self.up
    create_table "az_outboxes" do |t|
      t.integer    :mailing_id
      t.integer    :az_user_id
      t.boolean    :status, :null => false, :default => 0
      t.text       :e_message, :null => false
      t.datetime   :created
    end
  end

  def self.down
    drop_table "az_outboxes"
  end
end
