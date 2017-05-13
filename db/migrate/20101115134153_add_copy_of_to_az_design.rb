class AddCopyOfToAzDesign < ActiveRecord::Migration
  def self.up
    add_column :az_designs, :copy_of, :integer
  end

  def self.down
    remove_column  :az_designs, :copy_of
  end
end
