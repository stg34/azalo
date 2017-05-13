class CreateContacts < ActiveRecord::Migration
  def self.up
    create_table "contacts", :force => true do |t|
      t.column :my_id,      :integer, :null => false
      t.column :user_id,    :integer, :null => false
    end
  end

  def self.down
    drop_table "contacts"
  end
end
