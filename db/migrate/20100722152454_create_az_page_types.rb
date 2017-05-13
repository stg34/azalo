class CreateAzPageTypes < ActiveRecord::Migration
  def self.up
    create_table :az_page_types do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :az_page_types
  end
end
