class CreateAzTasks < ActiveRecord::Migration
  def self.up
    create_table :az_tasks do |t|
      t.string  :name
      t.text    :description
      t.decimal :estimated_time
      t.integer :az_base_data_type_id
      t.integer :parent_id
      t.integer :az_role_id

      t.timestamps
    end
  end

  def self.down
    drop_table :az_tasks
  end
end
