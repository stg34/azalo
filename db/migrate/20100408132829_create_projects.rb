class CreateProjects < ActiveRecord::Migration
  def self.up
    create_table :projects do |t|
      t.string    :name,                      :null => false
      t.string    :customer
      t.string    :favicon_file_name
      t.string    :favicon_content_type
      t.integer   :favicon_file_size
      t.datetime  :favicon_updated_at
      t.timestamps
    end
  end

  def self.down
    drop_table :projects
  end
end
