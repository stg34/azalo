class SetInvitationCounterToUser < ActiveRecord::Migration
  def self.up
    execute('update az_users set azalo_invitation_count=1000 where login="admin"')
    execute('update az_users set company_invitation_count=1000 where login="admin"')
  end

  def self.down
  end
end
