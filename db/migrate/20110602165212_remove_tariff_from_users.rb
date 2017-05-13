class RemoveTariffFromUsers < ActiveRecord::Migration
  def self.up
    remove_column :az_users, :az_tariff_id
    execute("delete from az_tariffs")
  end

  def self.down
    add_column :az_users, :az_tariff_id, :integer

    t = AzTariff.new
    t.name = 'Test'
    t.quota_disk = 209715200
    t.quota_active_projects = 3
    t.quota_components = 5
    t.quota_structures = 50
    t.quota_commons = 50
    t.quota_employees = 1
    t.position = 0
    t.tariff_type = 0
    t.save!

    execute("update az_users set az_tariff_id = #{t.id}")
  end
end
