class AddAssignedToProjectToBaseProject < ActiveRecord::Migration
  def self.up
    Authorization.current_user = AzUser.find_by_login('admin')
    add_column :az_base_projects, :parent_project_id, :integer

    blocks = AzProjectBlock.find(:all)
    blocks.each do |block|

      connected = ""
      
      if block.az_pages.size > 0
        parent_id = block.az_pages[0].get_project_over_block.id
        if parent_id == block.id
          parent_id = nil
        else
          connected = "connected"
        end
        block.parent_project_id = parent_id
        block.save!
      end

      puts "id: #{block.id} #{block.name}  #{connected}"
    end

  end

  def self.down
    remove_column :az_base_projects, :parent_project_id
  end
end
