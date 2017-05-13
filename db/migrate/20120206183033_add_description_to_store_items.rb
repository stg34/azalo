class AddDescriptionToStoreItems < ActiveRecord::Migration
  
  def self.up
      add_column 'az_store_items', :description, :text, :default => '', :null => false
      add_column 'az_store_items', :announce, :text, :default => '', :null => false
  end

  def self.down
      remove_column 'az_store_items', :description
      remove_column 'az_store_items', :announce
  end
end
