class AddSeedToTables < ActiveRecord::Migration
  @tables = ['az_base_projects',
             'az_base_data_types',
             'az_definitions',
             'az_commons',
             'az_operation_times']
  def self.up
    @tables.each do |table|
      add_column table, :seed, :boolean
    end
  end

  def self.down
    @tables.each do |table|
      remove_column table, :seed
    end
  end
end
