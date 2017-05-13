namespace :azalo  do
  desc "charge part of fee from end of test period till end of month"

  task :charge_part_of_fee => :environment do
    periods = AzTestPeriod.find(:all, :conditions => "state = 0 and ends_at < NOW()" )

    periods.each_with_index do |period, i|
      company = period.az_company
      if company == nil
        next
      end
      if company.ceo && company.ceo.login == 'admin' # Пропуск предзаготовленных компаний принадлежащих админу.
        next
      end
      puts "#{i}  charge fee from company #{company.name} #{company.id} fee = #{company.az_tariff.price}"
      company.charge_part_of_fee(period.ends_at)
      #break
    end
  end
end
