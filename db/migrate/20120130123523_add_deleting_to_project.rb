class AddDeletingToProject < ActiveRecord::Migration
  def self.up
    add_column :az_base_projects,  :deleting,  :boolean, :default => false
  end

  def self.down
    remove_column :az_base_projects,  :deleting
  end
end
