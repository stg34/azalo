class DropAzPageType < ActiveRecord::Migration
  def self.up
    drop_table :az_page_types
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
