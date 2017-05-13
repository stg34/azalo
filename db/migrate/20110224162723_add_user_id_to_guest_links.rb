class AddUserIdToGuestLinks < ActiveRecord::Migration
  def self.up
    add_column  :az_guest_links, :az_user_id, :integer
  end

  def self.down
    remove_column  :az_guest_links, :az_user_id
  end
end
