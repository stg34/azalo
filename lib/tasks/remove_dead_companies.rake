def counters1
  puts '--------------'
  puts "pages = #{AzPage.count(:all)}"
  puts "designs = #{AzDesign.count(:all)}"
  puts "sources = #{AzDesignSource.count(:all)}"
  puts "images = #{AzImage.count(:all)}"
  puts "commons = #{AzCommon.count(:all)}"
  puts '--------------'
end

namespace :azalo  do
  desc "remove_dead_companies"
  task :remove_dead_companies => :environment do

    companies = AzCompany.find(:all)
    #companies = AzCompany.find(:all, :conditions => {:id => 106})
    removed_companies_num = 0
    counters1
    companies.each_with_index do |company, i|
      if company.ceo.login == 'admin' # Пропуск предзаготовленных компаний принадлежащих админу.
        next
      end
      puts "#{i}"
      puts "company.ceo.all_logins.size = #{company.ceo.all_logins.size}"
      puts "company.created_at < Time.now - 6.month = #{company.created_at < Time.now - 6.month}"
      #if company.ceo.all_logins.size == 0 && company.created_at < Time.now - 6.month
      
      if company.created_at < Time.now - 6.month && company.projects.size == 1
        #puts "Removing #{company.name} #{company.id} #{company.az_tariff.name}"
        puts "company.projects.all.size = #{company.projects.all.size}"
        company.projects.all.each do |project|
          if project.copy_of == 355
            puts '------------------------------------------------------------------------------------------'

            puts "Removing project #{project.name} #{project.id}"
            puts "Company: #{company.name} #{company.id} #{company.az_tariff.name}"
            puts "Ceo: #{company.ceo.login} #{company.ceo.id} #{company.ceo.email}"
            puts "removed_companies_num = #{removed_companies_num}"
            project.destroy
            removed_companies_num += 1
          end
          
          puts '------------------------------------------------------------------------------------------'
        end
      end

      break if removed_companies_num > 1000
      
    end
    counters1
    puts "companies_ro_remove_num = #{removed_companies_num}"
  end
end


namespace :azalo  do
  desc "clean_dead_companies"
  task :clean_dead_companies => :environment do

    companies = AzCompany.find(:all)
    #companies = AzCompany.find(:all, :conditions => {:id => 106})
    removed_projects = 0
    removed_components = 0
    n = 0
    counters1
    companies.each_with_index do |company, i|
      if !(company.ceo.all_logins.size == 0 && company.created_at < Time.now - 6.month)
        next
      end
      if company.ceo.login == 'admin' # Пропуск предзаготовленных компаний принадлежащих админу.
        next
      end
      puts "#{n}"
      n += 1
      puts "Company: #{company.name} #{company.id} #{company.az_tariff.name}"
      puts "Ceo: #{company.ceo.login} #{company.ceo.id} #{company.ceo.email}"

      company.projects.all.each do |project|
        if project.copy_of == 355
          puts '------------------------------------------------------------------------------------------'
          puts "Removing project #{project.name} #{project.id}"
          project.destroy
          puts '------------------------------------------------------------------------------------------'
          removed_projects += 1
        end
      end

      company.project_blocks.all.each do |project_block|
        if project_block.copy_of == 5602
          puts '------------------------------------------------------------------------------------------'
          puts "Removing project_block #{project_block.name} #{project_block.id}"
          project_block.destroy
          puts '------------------------------------------------------------------------------------------'
          removed_components += 1
        end
      end
          
      
      puts "removed_projects = #{removed_projects}"
      puts "removed_components = #{removed_components}"
    end
    counters1
  end
end

namespace :azalo  do
  desc "remove_dead_companies2"
  task :remove_dead_companies2 => :environment do

    companies = AzCompany.find(:all)
    #companies = AzCompany.find(:all, :conditions => {:id => 106})
    removed_companies_num = 0
    companies.each_with_index do |company, i|
      if company.ceo.login == 'admin' # Пропуск предзаготовленных компаний принадлежащих админу.
        next
      end

      puts '------------------------------------------------------------------------------------------'
      puts "#{i}"
      puts "Company: #{company.name} #{company.id} #{company.az_tariff.name}"
      puts "Ceo: #{company.ceo.login} #{company.ceo.id} #{company.ceo.email}"

      company.destroy
      #puts "companies_ro_remove_num = #{removed_companies_num}"
    end
  end
end



