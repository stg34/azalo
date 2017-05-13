class AddIndexesToActivities < ActiveRecord::Migration
  def self.up
    add_index :az_activities, :user_id
    add_index :az_activities, :project_id
    add_index :az_activities, :created_at
  end

  def self.down
    remove_index :az_activities, :user_id
    remove_index :az_activities, :project_id
    remove_index :az_activities, :created_at
  end
end
