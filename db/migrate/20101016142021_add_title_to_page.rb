class AddTitleToPage < ActiveRecord::Migration
  def self.up
    add_column :az_pages,  :title,  :string, :default => ''
  end

  def self.down
    remove_column :az_pages,  :title
  end
end
