class RenameContactsToAzContacts < ActiveRecord::Migration
  def self.up
    rename_table "contacts", "az_contacts"
  end

  def self.down
    rename_table "az_contacts", "contacts"
  end
end
