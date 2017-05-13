class AddStateAndDescriptionToProjectStatuses < ActiveRecord::Migration
  def self.up
    add_column  :az_project_statuses, :state, :integer, :null => false, :default => 0
    add_column  :az_project_statuses, :description, :text, :null => false, :default => ''
  end

  def self.down
    remove_column  :az_project_statuses, :state
    remove_column  :az_project_statuses, :description
  end
end
