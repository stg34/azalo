class CreateImages < ActiveRecord::Migration
  def self.up
    create_table :images do |t|
      t.integer   :design_id,           :null => false
      #t.text      :description,         :null => false
      t.string    :image_file_name,     :null => false
      t.string    :image_content_type,  :null => false
      t.integer   :image_file_size,     :null => false
      t.datetime  :image_updated_at,    :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :images
  end
end
