class AddRmIdToProjects < ActiveRecord::Migration
  def self.up
    add_column :projects,  :rm_id,  :integer
  end

  def self.down
    remove_column :projects,  :rm_id
  end
end
