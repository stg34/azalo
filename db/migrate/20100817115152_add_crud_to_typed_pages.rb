class AddCrudToTypedPages < ActiveRecord::Migration
  def self.up
    add_column :az_typed_pages, :create_u, :boolean, :default => false
    add_column :az_typed_pages, :read_u,   :boolean, :default => false
    add_column :az_typed_pages, :update_u, :boolean, :default => false
    add_column :az_typed_pages, :delete_u, :boolean, :default => false

    add_column :az_typed_pages, :create_a, :boolean, :default => false
    add_column :az_typed_pages, :read_a,   :boolean, :default => false
    add_column :az_typed_pages, :update_a, :boolean, :default => false
    add_column :az_typed_pages, :delete_a, :boolean, :default => false
  end

  def self.down
    remove_column :az_typed_pages, :create_u
    remove_column :az_typed_pages, :read_u
    remove_column :az_typed_pages, :update_u
    remove_column :az_typed_pages, :delete_u

    remove_column :az_typed_pages, :create_a
    remove_column :az_typed_pages, :read_a
    remove_column :az_typed_pages, :update_a
    remove_column :az_typed_pages, :delete_a
  end
end
