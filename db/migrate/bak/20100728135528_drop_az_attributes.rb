class DropAzAttributes < ActiveRecord::Migration
  def self.up
    drop_table :az_attributes
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
