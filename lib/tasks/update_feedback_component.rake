#task :greet do
#   puts "Hello world"
#end

namespace :content  do
  desc "create some fake data"

  task :update_feedback_component => :environment do

    Authorization.current_user = AzUser.find_by_login('admin')

    id_to_remove = 2
    id_to_copy = 5602

    project_to_copy = AzProjectBlock.find(id_to_copy)


    puts "==================================================================================================="
    puts "==================================================================================================="
    puts "==================================================================================================="

    puts "Project #{project_to_copy.name} (#{project_to_copy.id}) is copiyng"
    
    blocks_to_destroy = AzProjectBlock.find(:all, :conditions => {:copy_of => id_to_remove})
    blocks_count = blocks_to_destroy.size
    i = 0

    blocks_to_destroy.each do |b|

      if b.owner.ceo.login == 'seeder'
        puts "--- skeep #{b.owner.ceo.login} ---"
        next
      end

      puts "#{i}/#{blocks_count}"
      b.destroy
      puts "#{b.name} (#{b.id}) is desroyed"
      #sleep 1
      i += 1
      #break
    end

    puts "==================================================================================================="
    puts "==================================================================================================="
    puts "==================================================================================================="

    i = 0
    companies = AzCompany.find(:all)
    companies_count = companies.size
    companies.each do |company|
      puts "#{i}/#{companies_count}"
      if company.ceo.login == 'seeder'
        puts "--- skeep #{company.ceo.login} ---"
        next
      end

      blocks_alredy_copied = AzProjectBlock.find(:first, :conditions => {:copy_of => id_to_copy, :owner_id => company.id})
      if blocks_alredy_copied != nil
        puts "#{company.ceo.login} alredy has copied component #{blocks_alredy_copied.id}"
        next
      end

      project_to_copy.make_copy(company)
      puts "Copeid to #{company.ceo.login}"
      i += 1
      #break
    end

    puts "==================================================================================================="
    puts "==================================================================================================="
    puts "==================================================================================================="


  end
end
