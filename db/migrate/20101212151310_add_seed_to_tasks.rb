class AddSeedToTasks < ActiveRecord::Migration
  
  def self.up
      add_column 'az_tasks', :seed, :boolean
  end

  def self.down
      remove_column 'az_tasks', :seed
  end
end
