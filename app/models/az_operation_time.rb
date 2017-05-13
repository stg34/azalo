class AzOperationTime < ActiveRecord::Base
  belongs_to :az_base_data_type
  belongs_to :az_operation

  # TODO fix owner_id
  #belongs_to :owner, :foreign_key => 'owner_id', :class_name => 'AzCompany'
  #include OwnerUtils

  # TODO validete az_base_data_type.owner_id == az_operation.owner_id == self.owner_id

end
