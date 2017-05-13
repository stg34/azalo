class AddCopyOfToDesignSources < ActiveRecord::Migration
  def self.up
    add_column :az_design_sources, :copy_of, :integer
    add_index :az_design_sources, :copy_of
  end

  def self.down
    remove_column :az_design_sources, :copy_of
  end
end
