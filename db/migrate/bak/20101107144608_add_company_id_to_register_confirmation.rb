class AddCompanyIdToRegisterConfirmation < ActiveRecord::Migration
  def self.up
    add_column :az_register_confirmations,  :company_id,  :integer
  end

  def self.down
    remove_column :az_register_confirmations,  :company_id
  end
end
