class DropAzDataTypes < ActiveRecord::Migration
  def self.up
    drop_table :az_data_types
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
