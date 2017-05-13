class CreateWorks < ActiveRecord::Migration
  def self.up
    create_table "works", :force => true do |t|
      t.column :user_id,      :integer, :null => false
      t.column :project_id,   :integer, :null => false
    end
  end

  def self.down
    drop_table "works"
  end
end
