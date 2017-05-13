class AddLyoutTimeToProjects < ActiveRecord::Migration
  def self.up
    add_column :az_base_projects, :layout_time, :float, :default => 0.0
  end

  def self.down
    remove_column :az_base_projects, :layout_time
  end
end
