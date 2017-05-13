namespace :azalo  do
  desc "set free tariff to all"
  task :set_free_tariff_to_all => :environment do

    free_tariff = AzTariff.find(:first, :conditions => {:price => 0.0, :tariff_type => 2})
    puts "Setting tariff #{free_tariff.name} to all"

    companies = AzCompany.find(:all)

    companies.each_with_index do |company, i|
      if company.ceo.login == 'admin' # Пропуск предзаготовленных компаний принадлежащих админу.
        next
      end
      puts "#{i}  charge tariff for company #{company.name} #{company.id}"
      company.change_tariff(free_tariff)
    end
  end
end
