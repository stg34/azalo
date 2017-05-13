class CreateAzGuestLinks < ActiveRecord::Migration
  def self.up
    create_table :az_guest_links do |t|
      t.string :hash_str, :null => false
      t.integer :az_base_project_id, :null => false
      t.datetime :expired_at, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :az_guest_links
  end
end
