class CreateAzTypedPages < ActiveRecord::Migration
  def self.up
    create_table :az_typed_pages do |t|
      t.integer :az_page_id
      t.integer :az_base_data_type_id

      t.timestamps
    end
  end

  def self.down
    drop_table :az_typed_pages
  end
end
