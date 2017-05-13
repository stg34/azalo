class CreateAzInvitations < ActiveRecord::Migration
  def self.up
    create_table :az_invitations do |t|
      #t.integer :owner_id, :null => false
      t.string :hash_str, :null => false
      t.string :email, :null => false
      t.string :invitation_type, :null => false
      t.integer :invitation_data, :null => false
      t.timestamps
    end
    #add_index :az_invitations, :hash_str, :unique => true
    #add_index :az_invitations, :email, :unique => true
  end

  def self.down
    drop_table :az_invitations
  end
end
