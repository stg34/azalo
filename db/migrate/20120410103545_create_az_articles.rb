class CreateAzArticles < ActiveRecord::Migration
  def self.up
    create_table :az_articles do |t|
      t.string :title
      t.text :announce
      t.text :text
      t.boolean :visible

      t.timestamps
    end
  end

  def self.down
    drop_table :az_articles
  end
end
