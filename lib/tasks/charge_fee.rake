namespace :azalo  do
  desc "charge fee"

  task :charge_fee => :environment do
    companies = AzCompany.find(:all)

    companies.each_with_index do |company, i|
      if company.ceo.login == 'admin' # Пропуск предзаготовленных компаний принадлежащих админу.
        next
      end
      #puts "#{i}  charge fee from company #{company.name} #{company.id} fee = #{company.az_tariff.price}"
      company.charge_fee
      #break
    end
  end
end
