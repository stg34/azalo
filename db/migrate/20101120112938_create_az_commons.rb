class CreateAzCommons < ActiveRecord::Migration
  def self.up
    create_table :az_commons do |t|
      t.integer :owner_id, :null => false
      t.integer :az_base_project_id
      t.string :name
      t.text :description
      t.string :comment
      t.string :type
      t.integer :copy_of

      t.timestamps
    end
  end

  def self.down
    drop_table :az_commons
  end
end
