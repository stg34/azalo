class AzSubscribtion < ActiveRecord::Base
  belongs_to :az_user
  belongs_to :az_subscribtion_category
end
