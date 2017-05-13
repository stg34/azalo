class AddIndexesToDefinitions < ActiveRecord::Migration
  def self.up
    add_index :az_definitions, :owner_id
    add_index :az_definitions, :copy_of
    add_index :az_definitions, :az_base_project_id
  end

  def self.down
    remove_index :az_definitions, :owner_id
    remove_index :az_definitions, :copy_of
    remove_index :az_definitions, :az_base_project_id
  end
end

