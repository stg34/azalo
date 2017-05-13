class AddSchemeToStoreItems < ActiveRecord::Migration
  
  def self.up
      add_column 'az_store_items', :scheme_file_name,     :string
      add_column 'az_store_items', :scheme_content_type,  :string
      add_column 'az_store_items', :scheme_file_size,     :integer
      add_column 'az_store_items', :scheme_updated_at,    :datetime
  end

  def self.down
      remove_column 'az_store_items', :scheme_file_name
      remove_column 'az_store_items', :scheme_content_type
      remove_column 'az_store_items', :scheme_file_size
      remove_column 'az_store_items', :scheme_updated_at
  end
end
