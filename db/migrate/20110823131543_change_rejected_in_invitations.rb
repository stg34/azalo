class ChangeRejectedInInvitations < ActiveRecord::Migration
  def self.up
    change_column :az_invitations, :rejected, :boolean, :default => nil, :null => true
    execute("update az_invitations set rejected = NULL where user_id is NULL")
  end

  def self.down
    change_column :az_invitations, :rejected, :boolean, :default => false, :null => false
  end
end
