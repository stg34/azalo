class ChangeNameAndDescriptionInTasks < ActiveRecord::Migration
  def self.up
    execute('update az_tasks set name="" where name is NULL')
    execute('update az_tasks set description="" where description is NULL')
    change_column :az_tasks, :name, :string, :null => false
    change_column :az_tasks, :description, :string, :null => false
  end

  def self.down
    change_column :az_tasks, :name, :string, :null => true
    change_column :az_tasks, :description, :string, :null => true
  end
end
