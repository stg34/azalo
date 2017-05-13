class AddPercentCompleteToProject < ActiveRecord::Migration
  def self.up
    add_column :az_base_projects, :percent_complete, :float, :null => false, :default => 0
  end

  def self.down
    remove_column  :az_base_projects, :percent_complete
  end
end
