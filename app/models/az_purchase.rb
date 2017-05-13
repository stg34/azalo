class AzPurchase < ActiveRecord::Base
  belongs_to :az_company
  belongs_to :az_store_item
end
