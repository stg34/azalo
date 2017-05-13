class ChangeTypeOfTimeInAzTask < ActiveRecord::Migration
  def self.up
    change_column :az_tasks, :estimated_time, :decimal, :precision =>24, :scale=>2
  end

  def self.down
    change_column :az_tasks, :estimated_time, :decimal
  end
end
