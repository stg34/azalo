class CreateAzCImages < ActiveRecord::Migration
  def self.up
    create_table :az_c_images do |t|
      t.integer :owner_id
      t.integer :az_c_image_category
      t.string    :c_image_file_name,     :null => false
      t.string    :c_image_content_type,  :null => false
      t.integer   :c_image_file_size,     :null => false
      t.datetime  :c_image_updated_at,    :null => false
      t.timestamps
    end
    add_index :az_c_images, :owner_id
  end

  def self.down
    drop_table :az_c_images
  end
end
