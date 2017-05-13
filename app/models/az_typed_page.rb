class AzTypedPage < OwnedActiveRecord

  attr_accessible :az_page_id, :az_base_data_type_id, :created_at, :updated_at, :owner_id, :copy_of

  # TODO validete az_page.owner_id == az_base_data_type.owner_id == self.owner_id
  
  belongs_to :az_page
  belongs_to :az_base_data_type

  has_many :az_typed_page_operations
  has_many :az_allowed_operations, :dependent => :destroy

  validate :validate_owner_id

  def validate_owner_id
    if az_page.owner_id != owner_id
      errors.add(:base, "Incorrect owner_id value. TypedPage has '#{az_page.owner_id}', page has '#{owner_id}'")
    end
  end

  def get_time_for_operations
    time = 0
#    az_typed_page_operations.each do |tpo|
#      operation = tpo.az_operation_time.az_operation
#      time += tpo.az_operation_time.az_base_data_type.get_operation_time(operation)
#      #time += tpo.az_operation_time.operation_time
#    end

    az_allowed_operations.each do |aop|
      operation = aop.az_operation
      time += az_base_data_type.get_operation_time(operation)
      #time += aop.az_operation_time.az_base_data_type.get_operation_time(operation)
      #time += tpo.az_operation_time.operation_time
    end
    return time
  end

  def remove_dependent_objects
    if az_base_data_type.copy_of != nil
      az_base_data_type.copy_of = nil
      az_base_data_type.save!
      az_base_data_type.destroy
    end
  end

  def self.from_az_hash(attributes, page_ids_original_copy, owner)
    typed_page = AzTypedPage.new(attributes)
    typed_page.owner = owner
    typed_page.az_page_id = page_ids_original_copy[attributes['az_page_id']]
    typed_page.copy_of = attributes['id']
    return typed_page
  end
  
end
