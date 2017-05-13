class CreateAzTariffs < ActiveRecord::Migration
  def self.up
    create_table :az_tariffs do |t|
      t.string :name
      t.decimal :price, :scale => 2, :precision => 9, :null => false, :default => 100.00
      t.integer :quota_disk,             :null => false, :default => 0
      t.integer :quota_active_projects,  :null => false, :default => 0
      t.integer :quota_components,       :null => false, :default => 0
      t.integer :quota_structures,       :null => false, :default => 0
      t.integer :quota_commons,          :null => false, :default => 0
      t.integer :quota_employees,        :null => false, :default => 0
      t.integer :position
      t.integer :tariff_type

      t.timestamps
    end
  end

  def self.down
    drop_table :az_tariffs
  end
end
