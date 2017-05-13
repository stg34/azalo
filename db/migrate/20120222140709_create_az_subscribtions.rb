class CreateAzSubscribtions < ActiveRecord::Migration
  def self.up
    create_table :az_subscribtions do |t|
      t.integer :az_user_id
      t.integer :az_subscribtion_category_id
      t.timestamps
    end
  end

  def self.down
    drop_table :az_subscribtions
  end
end
