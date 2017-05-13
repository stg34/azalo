class AddPositionsToTasks < ActiveRecord::Migration
  def self.up
    add_column :az_tasks, :position, :integer, :null => false
    execute('update az_tasks set position=id')
  end

  def self.down
    remove_column :az_tasks, :position
  end
end
