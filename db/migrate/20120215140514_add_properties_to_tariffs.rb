class AddPropertiesToTariffs < ActiveRecord::Migration
  
  def self.up
      add_column 'az_tariffs', :optimal,     :boolean
  end

  def self.down
      remove_column 'az_tariffs', :optimal
  end
end
