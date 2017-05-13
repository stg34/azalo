class AddDisckUsageToAzBaseProject < ActiveRecord::Migration
  def self.up
    add_column :az_base_projects, :disk_usage, :integer, :null => false, :default => 0
  end

  def self.down
    remove_column :az_base_projects, :disk_usage
  end
end
