class FixBaseProjectsPosition < ActiveRecord::Migration
  def self.up
    Authorization.current_user = AzUser.find_by_login('admin')
    i = 0
    companies = AzCompany.all
    companies.each do |cmp|
      puts i.to_s + " " + cmp.name
      i+=1
      projects = AzProject.all(:conditions => {:owner_id => cmp.id}, :order => :position)
      j = 0
      projects.each do |p|
        p.position = j
        p.save
        j += 1
      end

      blocks = AzProjectBlock.all(:conditions => {:owner_id => cmp.id}, :order => :position)
      j = 0
      blocks.each do |p|
        if p.pages_assigned_to.size == 0
          p.position = j
          p.save
          j += 1
        end
      end

    end
  end
  #blocks = AzProjectBlock.find(:all, :conditions => {:author_id => nil})
  #blocks.each do |bl|
  #  execute("update az_base_projects set author_id = #{bl.owner.ceo_id} where id=#{bl.id}")
  #end

  def self.down

  end
end
