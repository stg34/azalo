class AddPositionsToDefinitions < ActiveRecord::Migration
  def self.up
    add_column :az_definitions, :position, :integer, :null => false
    execute('update az_definitions set position=id')
  end

  def self.down
    remove_column :az_definitions, :position
  end
end
