class AddEmbeddedFlagToPage < ActiveRecord::Migration
  def self.up
    Authorization.current_user = AzUser.find_by_login('admin')
    
    add_column :az_pages, :embedded, :boolean

    blocks = AzProjectBlock.find(:all)
    
    blocks.each do |block|
      if block.az_pages.size > 0
        puts "id: #{block.id} #{block.name}"
        block.az_pages.each do |page|
          # Первую страницу публичной части длаем внедренной.
          if page.page_type == AzPage::Page_user && page.parent_id == nil
            page.embedded = true
            page.save!
          end
        end
      end


    end

  end

  def self.down
    remove_column :az_pages, :embedded
  end
end
