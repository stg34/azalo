class AddParentIdToAttributes < ActiveRecord::Migration
  def self.up
    add_column :az_attributes, :parent_id, :integer
  end

  def self.down
    remove_column :az_attributes, :parent_id
  end
end
