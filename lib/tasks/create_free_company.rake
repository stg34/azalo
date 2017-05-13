namespace :content  do
  desc "create company with default data"

  task :create_company => :environment do

    Authorization.current_user = AzUser.find_by_login('admin')

    puts "==================================================================================================="
    puts "==================================================================================================="
    puts "==================================================================================================="

    n = AzCompany.get_all_companies_wo_ceo.size

    puts "Companies without ceo count: #{n}"

    if n < 5
        AzCompany.create_company_with_content
    end
    
  end
end
