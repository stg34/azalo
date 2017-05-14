class AzOperation < ActiveRecord::Base
  #belongs_to :az_base_data_type
  has_many :az_operation_times, :dependent => :destroy

  #belongs_to :owner, :foreign_key => 'owner_id', :class_name => 'AzCompany'
  #include OwnerUtils

  # TODO validete az_base_data_type.owner_id == self.owner_id

end
