class AddOwnerIdToGuestLinks < ActiveRecord::Migration
  def self.up
    add_column 'az_guest_links', :owner_id, :integer, :null => false
    execute("UPDATE az_guest_links, az_base_projects SET az_guest_links.owner_id=az_base_projects.owner_id WHERE az_guest_links.az_base_project_id=az_base_projects.id")
  end

  def self.down
    remove_column 'az_guest_links', :owner_id
  end
end
