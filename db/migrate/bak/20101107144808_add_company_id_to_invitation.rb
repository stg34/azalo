class AddCompanyIdToInvitation < ActiveRecord::Migration
  def self.up
    add_column :az_invitations,  :company_id,  :integer
  end

  def self.down
    remove_column :az_invitations,  :company_id
  end
end
