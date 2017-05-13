class AddUrlToGuestLinks < ActiveRecord::Migration
  def self.up
    add_column  :az_guest_links, :url, :string
  end

  def self.down
    remove_column  :az_guest_links, :url
  end
end
