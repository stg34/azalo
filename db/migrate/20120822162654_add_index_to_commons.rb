class AddIndexToCommons < ActiveRecord::Migration
  def self.up
    add_index :az_commons, :az_base_project_id
    add_index :az_commons, :owner_id
  end

  def self.down
    remove_index :az_commons, :owner_id
    remove_index :az_commons, :az_base_project_id
  end
end
