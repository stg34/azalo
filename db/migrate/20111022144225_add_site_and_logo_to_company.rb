class AddSiteAndLogoToCompany < ActiveRecord::Migration

  def self.up
    add_column :az_companies, :logo_file_name,      :string
    add_column :az_companies, :logo_content_type,   :string
    add_column :az_companies, :logo_file_size,      :integer
    add_column :az_companies, :logo_updated_at,     :datetime

    add_column :az_companies, :site,                :string, :default => ''
  end

  def self.down
    remove_column :az_companies, :logo_file_name
    remove_column :az_companies, :logo_content_type
    remove_column :az_companies, :logo_file_size
    remove_column :az_companies, :logo_updated_at

    remove_column :az_companies, :site
  end

  
end
