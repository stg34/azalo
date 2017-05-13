class CreateAzMailingMessagesCategories < ActiveRecord::Migration
  def self.up

    create_table "az_mailing_messages_categories" do |t|
      t.integer    :az_mailing_message_id
      t.integer    :az_subscribtion_category_id
    end
  end

  def self.down
    drop_table "az_mailing_messages_categories"
  end
end
