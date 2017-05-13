class CreateAzProjectStatUpdates < ActiveRecord::Migration
  def self.up
    create_table :az_project_stat_updates do |t|
      t.timestamps
    end
  end

  def self.down
    drop_table :az_project_stat_updates
  end
end
