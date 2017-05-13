class SetProjectIdInStructsAndCollections < ActiveRecord::Migration

  def self.up
    Authorization.current_user = AzUser.find_by_login('admin')
    tps = AzTypedPage.find(:all)
    tps.each do |tp|
      dt = tp.az_base_data_type
      if dt.az_base_project == nil
        dt.az_base_project_id = tp.az_page.az_base_project_id
        puts dt.az_base_project_id
        dt.save!
      end
    end
  end

  def self.down
  end
end
