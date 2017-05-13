namespace :azalo  do
  desc "set free tariff to all"
  task :add_money_to_all => :environment do

    companies = AzCompany.find(:all)

    companies.each_with_index do |company, i|
      if company.ceo.login == 'admin' # Пропуск предзаготовленных компаний принадлежащих админу.
        next
      end
      puts "#{i}  charge tariff for company #{company.name} #{company.id}"
      company.az_tariff = free_tariff
      company.save
    end
  end
end
