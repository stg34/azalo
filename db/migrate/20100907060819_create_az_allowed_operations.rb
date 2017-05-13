class CreateAzAllowedOperations < ActiveRecord::Migration
  def self.up
    create_table :az_allowed_operations do |t|
      t.integer :az_typed_page_id
      t.integer :az_operation_id

      t.timestamps
    end
  end

  def self.down
    drop_table :az_allowed_operations
  end
end
