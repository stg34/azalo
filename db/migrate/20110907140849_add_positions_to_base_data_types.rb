class AddPositionsToBaseDataTypes < ActiveRecord::Migration
  def self.up
    add_column :az_base_data_types, :position, :integer, :null => false
    add_column :az_base_data_types, :tr_position, :integer
    execute('update az_base_data_types set position=id')
  end

  def self.down
    remove_column :az_base_data_types, :position
    remove_column :az_base_data_types, :tr_position
  end
end
