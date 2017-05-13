class AzPayment < ActiveRecord::Base
  #attr_accessible :amount, :comment, :user_id
  belongs_to :user
  belongs_to :az_company
end
