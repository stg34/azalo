class AddPublicToAzBaseProject < ActiveRecord::Migration
  def self.up
    add_column :az_base_projects, :public, :boolean, :default => false
  end

  def self.down
    remove_column :az_base_projects, :public
  end
end
