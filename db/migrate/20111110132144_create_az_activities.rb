class CreateAzActivities < ActiveRecord::Migration
  def self.up
    create_table "az_activities" do |t|
      t.column :action,                    :string,  :null => false
      t.column :model_name,                :string,  :null => false
      t.column :object_name,               :string
      t.column :model_id,                  :integer, :null => false
      t.column :owner_id,                  :integer, :null => false
      t.column :user_id,                   :integer, :null => false
      t.column :project_id,                :integer
      t.column :created_at,                :datetime
    end
    add_index :az_activities, :owner_id
  end

  def self.down
    drop_table "az_activities"
  end
end
