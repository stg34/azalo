class AddStatAttributesToProjects < ActiveRecord::Migration
  def self.up
    add_column :az_base_projects, :explorable, :boolean, :default => true
    add_column :az_base_projects, :forkable, :boolean, :default => true
    add_column :az_base_projects, :quality_correction, :float, :default => 1
    
  end

  def self.down
    remove_column :az_base_projects, :explorable
    remove_column :az_base_projects, :forkable
    remove_column :az_base_projects, :quality_correction
  end
end

