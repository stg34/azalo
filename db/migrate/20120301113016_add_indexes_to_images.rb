class AddIndexesToImages < ActiveRecord::Migration
  def self.up
    add_index :az_images, :az_design_id
    add_index :az_images, :owner_id
    add_index :az_images, :copy_of
  end

  def self.down
    remove_index :az_images, :az_design_id
    remove_index :az_images, :owner_id
    remove_index :az_images, :copy_of
  end
end
