#task :greet do
#   puts "Hello world"
#end

namespace :content  do
  desc "create some fake data"

  task :update_tr_texts => :environment do

    Authorization.current_user = AzUser.find_by_login('admin')
   
    companies = AzCompany.find(:all)

    seeds = AzTrText.find(:all, :conditions => {:seed => true, :id => 17})
    seed_ids = seeds.collect{|t| t.id}
    puts seed_ids.inspect
    texts_to_destroy = AzTrText.find(:all, :conditions => [ "copy_of IN (?)", seed_ids])

    texts_to_destroy.each_with_index do |text, i|
      if !seed_ids.include?(text.copy_of)
        puts 'Error'
        puts text.inspect
      else
        puts "destroy #{i}"
        text.destroy
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

  end
end
