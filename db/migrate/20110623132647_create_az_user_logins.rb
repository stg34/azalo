class CreateAzUserLogins < ActiveRecord::Migration
  def self.up
    create_table :az_user_logins do |t|
      t.integer :az_user_id
      t.string :ip
      t.string :browser

      t.timestamps
    end
  end

  def self.down
    drop_table :az_user_logins
  end
end
