class AddRejectedToInvitation < ActiveRecord::Migration
  def self.up
    add_column :az_invitations,  :rejected,  :boolean, :default => false, :null => false
  end

  def self.down
    remove_column :az_invitations,  :rejected
  end
end
