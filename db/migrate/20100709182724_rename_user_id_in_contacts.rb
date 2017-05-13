class RenameUserIdInContacts < ActiveRecord::Migration
  def self.up
    rename_column "contacts", "user_id", "az_user_id"
  end

  def self.down
    rename_column "contacts", "az_user_id", "user_id"
  end
end
