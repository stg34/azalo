class ChangeTariffType < ActiveRecord::Migration
  def self.up
    change_column :az_tariffs, :tariff_type, :int, :null => false
    change_column :az_tariffs, :position, :int, :null => false
  end

  def self.down
    change_column :az_tariffs, :tariff_type, :int, :null => true
    change_column :az_tariffs, :position, :int, :null => true
  end
end
