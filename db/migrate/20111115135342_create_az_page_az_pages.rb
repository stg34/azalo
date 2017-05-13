class CreateAzPageAzPages < ActiveRecord::Migration
  def self.up

    Authorization.current_user = AzUser.find_by_login('admin')


    create_table :az_page_az_pages do |t|
      t.integer :parent_page_id
      t.integer :page_id
      t.integer :position, :null => false
      t.timestamps
    end
    add_index :az_page_az_pages, :page_id
    add_index :az_page_az_pages, :parent_page_id

    #block_page_links = AzPageAzProjectBlock.find(:all, :conditions => {:id => 914})
    block_page_links = AzPageAzProjectBlock.find(:all)

    execute("insert into az_page_az_pages (page_id, parent_page_id, position, created_at, updated_at) select id, parent_id, position, created_at, updated_at from az_pages where parent_id is not null")

    puts "block_page_links size = #{block_page_links.size}"

    #admin_block_connections = {}
    block_page_links.each do |link|
      puts "================================================================================="
      puts "#{link.az_page.get_project_over_block.name} <------ #{link.az_project_block.name} (pages: #{link.az_project_block.az_pages.size})"
      project = link.az_page.get_project_over_block
      admin_pages = project.az_pages.select{|p| p.page_type == AzPage::Page_admin && p.parent == nil}

      if admin_pages.size > 0
        admin_page = admin_pages[0]
      end

      #if admin_page == nil
      #  raise 'admin page not found'
      #end

      link.az_project_block.az_pages.each do |cp|
        if cp.parent != nil
          next
        end
        puts "root page name: #{cp.name} "
        page_link = AzPageAzPage.new
        page_link.position = cp.position
        if cp.page_type == AzPage::Page_admin
          #if admin_block_connections[link.az_project_block.id] == nil
            #admin_block_connections[link.az_project_block.id] = admin_page
            page_link.az_parent_page = admin_page
            page_link.az_page = cp
          #end
        else
          page_link.az_parent_page = link.az_page
          page_link.az_page = cp
        end
        page_link.save!
        link.az_project_block.az_pages
      end
      puts "================================================================================="
    end
  end

  def self.down
    drop_table :az_page_az_pages
  end
end
