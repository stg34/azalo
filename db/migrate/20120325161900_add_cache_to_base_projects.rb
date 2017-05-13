class AddCacheToBaseProjects < ActiveRecord::Migration
  def self.up
    add_column :az_base_projects, :cache, :boolean, :null => false, :default => false
  end

  def self.down
    remove_column :az_base_projects, :cache
  end
end
