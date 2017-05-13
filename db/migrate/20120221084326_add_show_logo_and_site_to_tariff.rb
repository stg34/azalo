class AddShowLogoAndSiteToTariff < ActiveRecord::Migration
  def self.up
    add_column :az_tariffs, :show_logo_and_site, :boolean
  end

  def self.down
    remove_column :az_tariffs, :show_logo_and_site
  end
end
