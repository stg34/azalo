class AddPagesToAttributes < ActiveRecord::Migration
  def self.up
    add_column :az_attributes, :public_page, :boolean
    add_column :az_attributes, :admin_page, :boolean
  end

  def self.down
    remove_column :az_attributes, :public_page
    remove_column :az_attributes, :admin_page
  end
end
