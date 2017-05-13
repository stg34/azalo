class RemoveOwnerIdFromContacts < ActiveRecord::Migration
  def self.up
    remove_column :az_contacts, :owner_id
  end

  def self.down
    #add_column :az_contacts, :design_file_name, :string, :default => nil
  end
end
