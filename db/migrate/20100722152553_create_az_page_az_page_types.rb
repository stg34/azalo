class CreateAzPageAzPageTypes < ActiveRecord::Migration
  def self.up
    create_table :az_page_az_page_types do |t|
      t.integer :az_page
      t.integer :az_page_type

      t.timestamps
    end
  end

  def self.down
    drop_table :az_page_az_page_types
  end
end
