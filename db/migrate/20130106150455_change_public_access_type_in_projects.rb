class ChangePublicAccessTypeInProjects < ActiveRecord::Migration
  def self.up
    change_column :az_base_projects, :public_access, :boolean, :default => false, :null => false
  end

  def self.down
  end
end
