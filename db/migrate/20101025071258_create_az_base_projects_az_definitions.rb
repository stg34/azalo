class CreateAzBaseProjectsAzDefinitions < ActiveRecord::Migration
  def self.up
    create_table :az_base_projects_az_definitions do |t|
      t.integer :az_base_project_id
      t.integer :az_definition_id

      t.timestamps
    end
  end

  def self.down
    drop_table :az_base_projects_az_definitions
  end
end
