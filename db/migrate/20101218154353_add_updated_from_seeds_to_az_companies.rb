class AddUpdatedFromSeedsToAzCompanies < ActiveRecord::Migration
  def self.up
    add_column :az_companies, :updated_from_seeds, :datetime
  end

  def self.down
    remove_column  :az_companies, :updated_from_seeds
  end
end
