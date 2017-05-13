class AddNeverVisitedToAzUsers < ActiveRecord::Migration
  def self.up
    add_column :az_users, :never_visited, :boolean, :null => false, :default => true
  end

  def self.down
    remove_column  :az_users, :never_visited
  end
end
