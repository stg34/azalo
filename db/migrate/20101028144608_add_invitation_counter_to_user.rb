class AddInvitationCounterToUser < ActiveRecord::Migration
  def self.up
    add_column :az_users,  :azalo_invitation_count,  :integer, :default => 0
    add_column :az_users,  :company_invitation_count,  :integer, :default => 0
  end

  def self.down
    remove_column :az_users,  :azalo_invitation_count
    remove_column :az_users,  :company_invitation_count
  end
end
