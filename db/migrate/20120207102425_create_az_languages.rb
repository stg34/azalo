class CreateAzLanguages < ActiveRecord::Migration
  def self.up
    create_table :az_languages do |t|
      t.string      :name
      t.string      :english_name
      t.string      :code
      t.string      :lang_icon_file_name,     :null => false
      t.string      :lang_icon_content_type,  :null => false
      t.integer     :lang_icon_file_size,     :null => false
      t.datetime    :lang_icon_updated_at,    :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :az_languages
  end
end
