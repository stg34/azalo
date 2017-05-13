class CreateDesigns < ActiveRecord::Migration
  def self.up
    create_table :designs do |t|
      t.text      :description,         :null => false
      t.integer   :page_id,             :null => false

      #t.string    :image_file_name,     :null => false
      #t.string    :image_content_type
      #t.integer   :image_file_size
      #t.datetime  :image_updated_at
      
      t.string    :design_source_file_name
      t.string    :design_source_content_type
      t.integer   :design_source_file_size
      t.datetime  :design_source_updated_at

      t.timestamps
    end
  end

  def self.down
    drop_table :designs
  end
end

