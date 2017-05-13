class AddPageIdToAzProjectBlock < ActiveRecord::Migration
  def self.up
    add_column :az_base_projects, :az_page_id, :integer
  end

  def self.down
    remove_column :az_base_projects, :az_page_id
  end
end
