class CreateAzNews < ActiveRecord::Migration
  def self.up
    create_table :az_news do |t|
      t.string :title, :null => false
      t.text :announce, :null => false
      t.text :body, :null => false
      t.boolean :visible, :null => false, :default => false
      t.integer :az_user_id, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :az_news
  end
end
