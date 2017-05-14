class AzVariable < OwnedActiveRecord

  # TODO validate az_base_data_type.owner_id == az_struct_data_type.owner_id == self.owner_id

  belongs_to :az_base_data_type
  belongs_to :az_struct_data_type

  has_many :az_validators, :dependent => :destroy

  validates_length_of   :name, :within => 1..32
  validates_presence_of :az_base_data_type
  validates_presence_of :az_struct_data_type # Переменная должна принадлежать структуре. Она не может вистеь в воздухе

  acts_as_list :scope => :az_struct_data_type_id

  def validate
    validate_owner_id
  end

  def validate_owner_id
    if az_struct_data_type && az_struct_data_type.owner_id != owner_id
      errors.add_to_base("Incorrect owner_id value. Structure has '#{az_struct_data_type.owner_id}', variable has '#{owner_id}'")
    end
  end

  def self.get_model_name
    return "Переменная"
  end

  def to_az_hash
    struct_hash = attributes
    struct_hash["az_validators"] = az_validators.map{|v| v.attributes}
    return struct_hash
  end

  def self.from_az_hash(attributes, project, struct_ids_original_copy, collection_ids_original_copy)
    var = AzVariable.new(attributes)

    var.copy_of = attributes['id']
    var.owner = project.owner

    var.az_struct_data_type_id = struct_ids_original_copy[attributes['az_struct_data_type_id']]

    az_base_data_type_id = struct_ids_original_copy[attributes['az_base_data_type_id']] || collection_ids_original_copy[attributes['az_base_data_type_id']]
    if az_base_data_type_id != nil
      var.az_base_data_type_id = az_base_data_type_id
    else
      # Simple data type, no need to be changed
      var.az_base_data_type_id = attributes['az_base_data_type_id']
    end
    return var
  end

  def make_copy_variable(owner, project, parent_struct)
    dup = self.clone

    #copy for belongs_to :az_base_data_type

    ret = dup.az_base_data_type.find_copied_or_make_copy(owner, project)
    
    dup.az_base_data_type = ret

    dup.az_struct_data_type = parent_struct
    dup.copy_of = id
    dup.owner = owner

    az_validators.each do |val|
      val.make_copy_validator(dup.owner, dup)
    end

    dup.save!
    return dup
  end

  def add_validator(validator)
    validator.make_copy_validator(self.owner, self)
  end

  def remove_validator(validator)
    validator.destroy
  end

  def get_crumbs_to_parent
    crumbs = [{:name => name, :type => 'Переменная', :parent => az_struct_data_type, :url => {:controller => "az_variables", :action => 'edit', :id => self.id}}]
    if az_struct_data_type
      crumbs.concat(az_struct_data_type.get_crumbs_to_parent)
    end
    return crumbs
  end


  def get_project
    if az_struct_data_type == nil
      return nil
    end
    return az_struct_data_type.get_project
  end

end
