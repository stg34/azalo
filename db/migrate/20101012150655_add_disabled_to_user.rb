class AddDisabledToUser < ActiveRecord::Migration
  def self.up
    add_column :az_users,  :disabled,  :boolean, :default => true
    execute('update az_users set disabled=false')
  end

  def self.down
    remove_column :az_users,  :disabled
  end
end
