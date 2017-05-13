namespace :azalo  do
  desc "create cash warning"

  task :create_cash_warning => :environment do
    companies = AzCompany.find(:all)
    companies.each_with_index do |company, i|
      if company.ceo.login == 'admin' # Пропуск предзаготовленных компаний принадлежащих админу.
        next
      end
      company.create_warning_period
      puts "#{i}  checking cash warning for #{company.name}"
      #break
    end
  end
end
