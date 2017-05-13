class CreateAzTypedPageOperations < ActiveRecord::Migration
  def self.up
    create_table :az_typed_page_operations do |t|
      t.integer :az_operation_time_id
      t.integer :az_typed_page_id

      t.timestamps
    end
  end

  def self.down
    drop_table :az_typed_page_operations
  end
end
