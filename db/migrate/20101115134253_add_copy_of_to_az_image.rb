class AddCopyOfToAzImage < ActiveRecord::Migration
  def self.up
    add_column :az_images, :copy_of, :integer
  end

  def self.down
    remove_column  :az_images, :copy_of
  end
end
