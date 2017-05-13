class AddCopyOfToAzPage < ActiveRecord::Migration
  def self.up
    add_column :az_pages, :copy_of, :integer
  end

  def self.down
    remove_column  :az_pages, :copy_of
  end
end
