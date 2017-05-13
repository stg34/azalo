class CreateAzParticipants < ActiveRecord::Migration
  def self.up
    create_table :az_participants do |t|
      t.integer :az_project_id
      t.integer :az_user_id
      t.integer :az_rm_role_id

      t.timestamps
    end
  end

  def self.down
    drop_table :az_participants
  end
end
