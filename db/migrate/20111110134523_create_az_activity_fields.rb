class CreateAzActivityFields < ActiveRecord::Migration
  def self.up
    create_table "az_activity_fields" do |t|
      t.column :az_activity_id,           :integer, :null => false
      t.column :field,                    :string,  :null => false
      t.column :old_value,                :text
      t.column :new_value,                :text
    end
    add_index :az_activity_fields, :az_activity_id
  end

  def self.down
    drop_table "az_activity_fields"
  end
end
