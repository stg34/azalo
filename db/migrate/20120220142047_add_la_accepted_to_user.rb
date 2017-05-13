class AddLaAcceptedToUser < ActiveRecord::Migration
  def self.up
    add_column :az_users, :la_accepted, :boolean
  end

  def self.down
    remove_column :az_users, :la_accepted
  end
end
