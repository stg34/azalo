class AddManualAndLanguageToStoreItems < ActiveRecord::Migration
  
  def self.up
      add_column 'az_store_items', :manual, :text, :default => '', :null => false
      add_column 'az_store_items', :az_language_id, :integer
      add_column 'az_store_items', :az_scetch_program_id, :integer

  end

  def self.down
      remove_column 'az_store_items', :manual
      remove_column 'az_store_items', :az_language_id
      remove_column 'az_store_items', :az_scetch_program_id
  end
end
