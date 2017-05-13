require "vendor/plugins/declarative_authorization/lib/declarative_authorization/maintenance"

class AddFirstUser < ActiveRecord::Migration
  def self.up
    AzUser.set_registration_open(true)
    ApplicationController.set_guest_project_ids([0])
    Authorization::Maintenance::without_access_control do
      u = AzUser.create(:login => 'admin', :email => 'boris@stg.dp.ua', :name => 'Boris', :lastname => 'Mikhailenko', :password => 'AWDwRthw', :password_confirmation => 'AWDwRthw', :roles => (['admin'] || []).map {|r| r.to_sym})
      u.save!
      u = AzUser.create(:login => 'seeder', :email => 'boris@stargazer.dp.ua', :name => 'Boris', :lastname => 'Mikhailenko', :password => 'AWDwRthw', :password_confirmation => 'AWDwRthw', :roles => (['user', 'seeder'] || []).map {|r| r.to_sym})
      u.save!
      #u.save(false)
    end
  end

  def self.down
    Authorization::Maintenance::without_access_control do
      u = AzUser.find_by_login("admin")
      u.destroy if u
    end
  end
end
