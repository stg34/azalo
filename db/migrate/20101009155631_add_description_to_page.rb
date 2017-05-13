class AddDescriptionToPage < ActiveRecord::Migration
  def self.up
    add_column :az_pages, :description, :text
  end

  def self.down
    remove_column :az_pages, :description
  end
end
