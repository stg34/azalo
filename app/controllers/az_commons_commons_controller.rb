class AzCommonsCommonsController < AzCommonsController

  filter_access_to :index_user, :new, :create
  filter_access_to :all, :attribute_check => true

end
