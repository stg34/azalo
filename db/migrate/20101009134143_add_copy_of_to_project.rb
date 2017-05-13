class AddCopyOfToProject < ActiveRecord::Migration
  def self.up
    add_column :az_base_projects, :copy_of, :integer
  end

  def self.down
    remove_column  :az_base_projects, :copy_of
  end
end
