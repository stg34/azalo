class AddRootPageToBaseProject < ActiveRecord::Migration
  def self.up
    add_column :az_pages, :root, :boolean
  end

  def self.down
    remove_column :az_pages, :root
  end
end
