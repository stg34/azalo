class CreateAzSubscribtionCategories < ActiveRecord::Migration
  def self.up
    create_table :az_subscribtion_categories do |t|
      t.string :name
      t.integer :sort_order
      t.timestamps
    end
  end

  def self.down
    drop_table :az_subscribtion_categories
  end
end
