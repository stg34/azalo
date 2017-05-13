class MergeUserAndAdminOperations < ActiveRecord::Migration
  def self.up
    remove_column :az_typed_pages,  :create_a
    remove_column :az_typed_pages,  :read_a
    remove_column :az_typed_pages,  :update_a
    remove_column :az_typed_pages,  :delete_a

    rename_column :az_typed_pages, :create_u, :operation_create
    rename_column :az_typed_pages, :read_u,   :operation_read
    rename_column :az_typed_pages, :update_u, :operation_update
    rename_column :az_typed_pages, :delete_u, :operation_delete
  end

  def self.down
    rename_column :az_typed_pages, :operation_create, :create_u
    rename_column :az_typed_pages, :operation_read,   :read_u
    rename_column :az_typed_pages, :operation_update, :update_u
    rename_column :az_typed_pages, :operation_delete, :delete_u

    add_column :az_typed_pages,  :create_a, :float, :default => 0.0
    add_column :az_typed_pages,  :read_a,   :float, :default => 0.0
    add_column :az_typed_pages,  :update_a, :float, :default => 0.0
    add_column :az_typed_pages,  :delete_a, :float, :default => 0.0
    
    execute('update az_typed_pages set create_a=create_u')
    execute('update az_typed_pages set read_a=read_u')
    execute('update az_typed_pages set update_a=update_u')
    execute('update az_typed_pages set delete_a=delete_u')
  end
end
