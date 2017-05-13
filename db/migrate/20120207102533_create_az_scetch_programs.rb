class CreateAzScetchPrograms < ActiveRecord::Migration
  def self.up
    create_table :az_scetch_programs do |t|
      t.string :name
      t.string :url
      t.text :description
      t.string    :sp_icon_file_name,     :null => false
      t.string    :sp_icon_content_type,  :null => false
      t.integer   :sp_icon_file_size,     :null => false
      t.datetime  :sp_icon_updated_at,    :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :az_scetch_programs
  end
end
