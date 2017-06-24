class AzInvoice < ActiveRecord::Base
  belongs_to :az_balance_transaction
  has_many :az_bills, :dependent => :destroy

  def get_total_fee
    
    sum = az_bills.inject{|sum, b| sum + b.fee }
    sum = 0
    az_bills.each{ |b| sum+=b.fee }


    puts '--------------------------------------------------------------------------'
    puts az_bills.size
    puts sum
    az_bills.each do |b|
      puts b.fee
    end
    return sum
  end

end
