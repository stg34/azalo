namespace :azalo  do
  desc "finance_amnisty"
  task :finance_amnisty => :environment do

    companies = AzCompany.find(:all)
    cmp_ids = []
    companies.each_with_index do |company, i|
      if company.ceo.login == 'admin' # Пропуск предзаготовленных компаний принадлежащих админу.
        next
      end
      next if company.get_balance >= 0
      next if company.az_balance_transactions.size < 2
      bts = company.az_balance_transactions.reverse
      next if !(bts[0].description.to_s =~ /Оплата по тарифу/ && bts[1].description.to_s =~ /Оплата по тарифу/)
      puts '------------------------------------------------------------'
      puts "#{i} Компания должник, претендент на амнистию #{company.name} #{company.id}"
      puts "Счет: #{company.get_balance}"
      company.az_balance_transactions.each do |t|
        puts "#{t.created_at} #{t.description}"
      end

      bts.each do |bt|
        if company.get_balance - bt.amount < 0
          puts "removed transaction #{bt.amount} #{bt.description} #{bt.created_at}"
          btr = AzBalanceTransaction.find(bt.id)
          btr.destroy
        end
      end
      cmp_ids << company.id

      puts "Счет после амнистии: #{company.get_balance}"
      puts '------------------------------------------------------------'
      
    end
    puts '==============================================================================='
    puts 'Амнистированные компании:'
    companies = AzCompany.find(cmp_ids)
    companies.each do |company|
      puts "#{company.name} (#{company.id})  Баланс: #{company.get_balance}"
    end
  end
end
