class DropWorks < ActiveRecord::Migration
  def self.up
    drop_table "works"
  end

  def self.down
    create_table "works", :force => true do |t|
      t.column :user_id,      :integer, :null => false
      t.column :project_id,   :integer, :null => false
    end
  end
end
