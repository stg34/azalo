class AzTypedPageOperation < ActiveRecord::Base

  # TODO fix owner_id
#  belongs_to :owner, :foreign_key => 'owner_id', :class_name => 'AzCompany'
#  include OwnerUtils
#

  # TODO validete az_typed_page.owner_id == az_operation_time.owner_id == self.owner_id

  belongs_to :az_typed_page
  belongs_to :az_operation_time
end
