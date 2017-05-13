class CreatePages < ActiveRecord::Migration
  def self.up
    create_table :pages do |t|
      t.string  :name,        :null => false
      t.integer :project_id,  :null => false
      t.integer :position,    :null => false
      t.integer :parent_id
      #t.integer :lft
      #t.integer :rgt
      t.string  :design_file_name
      t.decimal :estimated_time, :precision => 8, :scale => 1
      t.timestamps
    end
  end

  def self.down
    drop_table :pages
  end
end
