class CreateAzCompanies < ActiveRecord::Migration
  def self.up
    create_table :az_companies do |t|
      t.string :name, :null => false
      t.integer :ceo_id, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :az_companies
  end
end
