class CreateAzCollectionTemplates < ActiveRecord::Migration
  def self.up
    create_table :az_collection_templates do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :az_collection_templates
  end
end
