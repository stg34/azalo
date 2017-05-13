class AddOwnerIdToAllTables < ActiveRecord::Migration
  @tables = [
             #'az_base_projects',
             'az_allowed_operations',
             'az_base_data_types',
             'az_base_projects_az_definitions',
             'az_collection_templates',
             'az_contacts',
             'az_definitions',
             'az_designs',
             'az_employees',
             'az_images',
             'az_operation_times',
             #'az_operations',
             'az_page_az_page_types',
             'az_pages',
             'az_participants',
             #'az_project_definitions',
             #'az_register_confirmations',
             'az_tasks',
             'az_typed_page_operations',
             'az_typed_pages',
             'az_variables'
            ]
  def self.up
    @tables.each do |table|
      add_column table, :owner_id, :integer, :null => false
      execute("update #{table} set owner_id=2")
    end
  end

  def self.down
    @tables.each do |table|
      remove_column table, :owner_id
    end
  end
end
