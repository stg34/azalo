class AddNoteToUser < ActiveRecord::Migration
  def self.up
    add_column :az_users, :note, :text, :default => '', :null => false
  end

  def self.down
    remove_column :az_users, :note
  end
end
