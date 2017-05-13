class CreateAzDefinitions < ActiveRecord::Migration
  def self.up
    create_table :az_definitions do |t|
      t.string :name
      t.text :definition
      t.integer :az_user_id
      t.integer :az_base_project_id

      t.timestamps
    end
  end

  def self.down
    drop_table :az_definitions
  end
end
