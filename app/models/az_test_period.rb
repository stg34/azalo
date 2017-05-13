class AzTestPeriod < AzUsingPeriod
  
  Part_of_fee_not_charged = 0
  Part_of_fee_charged = 1

  belongs_to :az_company
end
