class AddCopyOfToAzVariable < ActiveRecord::Migration
  def self.up
    add_column :az_variables, :copy_of, :integer
  end

  def self.down
    remove_column  :az_variables, :copy_of
  end
end
