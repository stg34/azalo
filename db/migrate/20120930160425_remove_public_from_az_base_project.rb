class RemovePublicFromAzBaseProject < ActiveRecord::Migration
  def self.up
    remove_column :az_base_projects, :public
  end

  def self.down
    add_column :az_base_projects, :public, :boolean, :default => false
  end
  
end
