class AddPositionsToCommons < ActiveRecord::Migration
  def self.up
    add_column :az_commons, :position, :integer, :null => false
    execute('update az_commons set position=id')
  end

  def self.down
    remove_column :az_commons, :position
  end
end
