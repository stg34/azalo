class AzAllowedOperation < OwnedActiveRecord

  attr_accessible :az_operation_id, :az_typed_page_id, :owner_id, :created_at, :updated_at, :copy_of, :az_typed_page, :az_operation

  # TODO validete az_typed_page.owner_id == az_operation.owner_id == self.owner_id

  belongs_to :az_typed_page
  belongs_to :az_operation

  validate :validate_owner_id

  def validate_owner_id
    if az_typed_page.owner_id != owner_id
      errors.add(:base, "Incorrect owner_id value. TypedPage has '#{az_typed_page.owner_id}', AllowedOperation has '#{owner_id}'")
    end
  end

  def get_operation_name
    if az_operation != nil
      return az_operation.name
    end
  end

  def self.from_az_hash(attributes, typed_page_ids_original_copy, owner)
    allowed_operation = AzAllowedOperation.new(attributes)
    allowed_operation.az_typed_page_id = typed_page_ids_original_copy[attributes['az_typed_page_id']]
    allowed_operation.owner = owner
    allowed_operation.copy_of = attributes['id']
    return allowed_operation
  end

end
