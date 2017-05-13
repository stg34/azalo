class CreateAzPageAzProjectBlocks < ActiveRecord::Migration
  def self.up
    create_table :az_page_az_project_blocks do |t|
      t.integer :az_page_id, :null => false
      t.integer :az_base_project_id, :null => false
      t.string :name
      t.timestamps
    end

    Authorization.current_user = AzUser.find_by_login('admin')
    
    blocks = AzProjectBlock.all
    blocks.each do |block|
      if block.az_page_id != nil
        pb = AzPageAzProjectBlock.new(:az_page_id => block.az_page_id, :az_base_project_id => block.id)
        pb.save!
      end
    end
    remove_column :az_base_projects, :az_page_id
  end

  def self.down

    add_column :az_base_projects, :az_page_id, :integer

    Authorization.current_user = AzUser.find_by_login('admin')

    pbs = AzPageAzProjectBlock.all
    pbs.each do |pb|
      block = AzProjectBlock.find(pb.az_base_project_id)
      if block != nil
        block.az_page_id = pb.az_page_id
        block.save!
      end
    end

    drop_table :az_page_az_project_blocks
  end
end
