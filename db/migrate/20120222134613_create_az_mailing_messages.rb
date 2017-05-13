class CreateAzMailingMessages < ActiveRecord::Migration
  def self.up
    create_table "az_mailing_messages" do |t|
      t.string    :name
      t.string    :subject
      t.text      :text
      t.boolean  :active
      t.boolean  :force
      t.datetime :created
    end
  end

  def self.down
    drop_table "az_mailing_messages"
  end
end
