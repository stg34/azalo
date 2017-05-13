class AddProjectQuotasToTariffs < ActiveRecord::Migration
  
  def self.up
    add_column 'az_tariffs', :quota_public_projects,     :integer, :default => 0
    add_column 'az_tariffs', :quota_private_projects,    :integer, :default => 0
  end

  def self.down
    remove_column 'az_tariffs', :quota_private_projects
    remove_column 'az_tariffs', :quota_public_projects
  end
end
