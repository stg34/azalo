class SetRootPageToBaseProject < ActiveRecord::Migration
  def self.up
       
    #projects = AzBaseProject.find(:all, :conditions => ["id > 4500 and id < 4700 and owner_id = 3"])
    #projects = AzBaseProject.find(:all, :conditions => ["owner_id = 3"])
    projects = AzBaseProject.find(:all)
    projects.each do |project|
      puts "=================================================================="
      puts "#{project.name} #{project.id}"
      #project = AzProject.find(4632)

      pages = project.az_pages


      roots =  pages.select{|page| page.parents.select{|p| p.az_base_project_id == project.id}.size == 0}
      roots.each do |r|
        puts "#{r.name} - #{r.id} - #{r.az_base_project_id}"
      end

      root = AzPage.new
      root.name = 'root'
      root.az_base_project = project
      root.position = 0
      root.root = true
      
      root.owner = project.owner
      root.save!

      roots.each_with_index do |r, i|
        link = AzPageAzPage.new
        link.az_page = r
        link.az_parent_page = root
        link.position = i
        puts "link: parent: #{root.id}   page: #{r.id}   position: #{i}"
        link.save!
      end
    end
    
  end

  def self.down
    
  end
end
