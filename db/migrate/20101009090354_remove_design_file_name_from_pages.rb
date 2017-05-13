class RemoveDesignFileNameFromPages < ActiveRecord::Migration
  def self.up
    remove_column :az_pages, :design_file_name
  end

  def self.down
    add_column :az_pages, :design_file_name, :string, :default => nil
  end
end
