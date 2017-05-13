class AddPageTypeToAzPage < ActiveRecord::Migration
  def self.up
    add_column :az_pages, :page_type, :integer, :default => 0
  end

  def self.down
    remove_column  :az_pages, :page_type
  end
end
