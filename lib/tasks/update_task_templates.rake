#task :greet do
#   puts "Hello world"
#end

namespace :content  do
  desc "create some fake data"

  task :update_task_templates => :environment do

    Authorization.current_user = AzUser.find_by_login('admin')

    
    id_to_copy = 5602
    companies = AzCompany.find(:all)

    seeds = AzTask.find(:all, :conditions => {:seed => true})
    seed_ids = seeds.collect{|t| t.id}
    puts seed_ids.inspect
    tasks_to_destroy = AzTask.find(:all, :conditions => [ "copy_of IN (?)", seed_ids])

    tasks_to_destroy.each_with_index do |task, i|
      if !seed_ids.include?(task.copy_of)
        puts 'Error'
        puts task.inspect
      else
        puts "destroy #{i}"
        task.destroy
      end
    end

    companies.each_with_index do |company, i|
      puts "#{i}  copying to company #{company.name}"
      if company.id == 2 # seeder
        next
      end
      seeds.each do |s|
        s.make_copy(company)
      end
    end


#    puts "==================================================================================================="
#    puts "==================================================================================================="
#    puts "==================================================================================================="
#
#    puts "Project #{project_to_copy.name} (#{project_to_copy.id}) is copiyng"
#
#    blocks_to_destroy = AzProjectBlock.find(:all, :conditions => {:copy_of => id_to_remove})
#    blocks_count = blocks_to_destroy.size
#    i = 0
#
#    blocks_to_destroy.each do |b|
#
#      if b.owner.ceo.login == 'seeder'
#        puts "--- skeep #{b.owner.ceo.login} ---"
#        next
#      end
#
#      puts "#{i}/#{blocks_count}"
#      b.destroy
#      puts "#{b.name} (#{b.id}) is desroyed"
#      #sleep 1
#      i += 1
#      #break
#    end
#
#    puts "==================================================================================================="
#    puts "==================================================================================================="
#    puts "==================================================================================================="
#
#    i = 0
#
#    companies_count = companies.size
#    companies.each do |company|
#      puts "#{i}/#{companies_count}"
#      if company.ceo.login == 'seeder'
#        puts "--- skeep #{company.ceo.login} ---"
#        next
#      end
#
#      blocks_alredy_copied = AzProjectBlock.find(:first, :conditions => {:copy_of => id_to_copy, :owner_id => company.id})
#      if blocks_alredy_copied != nil
#        puts "#{company.ceo.login} alredy has copied component #{blocks_alredy_copied.id}"
#        next
#      end
#
#      project_to_copy.make_copy(company)
#      puts "Copeid to #{company.ceo.login}"
#      i += 1
#      #break
#    end
#
#    puts "==================================================================================================="
#    puts "==================================================================================================="
#    puts "==================================================================================================="


  end
end
