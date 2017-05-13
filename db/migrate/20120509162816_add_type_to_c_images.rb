class AddTypeToCImages < ActiveRecord::Migration
  def self.up
    add_column :az_c_images, :item_type, :string
    add_column :az_c_images, :item_id, :integer
  end

  def self.down
    remove_column :az_c_images, :item_type
    remove_column :az_c_images, :item_id
  end
end
