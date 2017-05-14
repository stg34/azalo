class AzCommon < OwnedActiveRecord

  include Statuses

  belongs_to :az_base_project

  validates_presence_of     :name
  validates_presence_of     :description

  def validate
    validate_owner_id_common('common', 'Project')
  end
  
  # TODO validete az_common.owner_id == az_base_project.owner_id

  def before_create
    self.set_initial_position
  end

  def self.get_by_company(company)
    return find_all_by_owner_id(company.id, :conditions => {:az_base_project_id => nil}, :order => :position)
  end

  def self.get_by_project(project)
    return find_all_by_az_base_project_id(project.id)
  end

  def self.get_label
    "Что-то общее"
  end

  def self.get_model_name
    return self.get_label
  end

  def self.get_child_classes
    return [AzCommonsCommon,
           AzCommonsAcceptanceCondition,
           AzCommonsContentCreation,
           AzCommonsPurposeExploitation,
           AzCommonsPurposeFunctional,
           AzCommonsRequirementsHosting,
           AzCommonsRequirementsReliability, 
           AzCommonsFunctionality]
  end

  def self.from_az_hash(attributes, project)
    common = AzCommon.new(attributes)
    common.copy_of = attributes['id']
    common.type = attributes['type']
    common.az_base_project = project
    common.owner = project.owner
    return common
  end

  def make_copy_common(owner, project)
    dup = self.clone
    dup.copy_of = id
    dup.owner = owner
    dup.az_base_project = project
    dup.seed = false
    dup.save!
    dup.position = dup.id
    dup.save!
    return dup
  end

  def self.get_seeds
    return find_all_by_seed(true)
  end

  def update_from_source(src)
    self.name = src.name
    self.description = src.description
    self.comment = src.comment
    self.save!
  end

  def sow(owner)
    result = nil

    if self.seed != true
      return result
    end

    common_to_update = AzCommon.find(:first, :conditions => {:owner_id => owner.id, :copy_of => self.id, :az_base_project_id => nil})
    if common_to_update == nil
      self.make_copy_common(owner, nil)
      result = [self, 'copied']
    else
      common_to_update.update_from_source(self)
      result = [self, 'updated']
    end

    return [result]
  end

  def self.update_from_seed(owner)
    result = []
    seeds = AzCommon.get_seeds
    seeds.each do |s|
      res = s.sow(owner)
      if res != nil
        result.concat(res)
      end
    end

    return result
  end

  def move_up
    
    c_type = self["type"]

    conditions = "position < #{self.position} AND type = '#{c_type}'"
    if self.az_base_project_id == nil
      conditions += " AND az_base_project_id is NULL"
    else
      conditions += " AND az_base_project_id=#{self.az_base_project_id}"
    end

    common = AzCommon.find_last_by_owner_id(owner_id, :conditions => conditions, :order => 'position asc')

    if common == nil
      return # Мы выше всех
    end

    common.position, self.position = self.position, common.position

    common.save
    self.save
  end

  def move_down

    c_type = self["type"]

    conditions = "position > #{self.position} AND type = '#{c_type}'"
    if self.az_base_project_id == nil
      conditions += " AND az_base_project_id is NULL"
    else
      conditions += " AND az_base_project_id=#{self.az_base_project_id}"
    end

    common = AzCommon.find_last_by_owner_id(owner_id, :conditions => conditions, :order => 'position desc')

    if common == nil
      return # Мы ниже всех
    end

    common.position, self.position = self.position, common.position

    common.save
    self.save
  end

  def set_initial_position
    c = AzCommon.find(:last, :order => :id)
    if c == nil
      self.position = 1
    else
      self.position = c.id + 1
    end
  end

  def to_az_hash
    attrs = attributes
    #attrs.delete("id")
    #attrs.delete("created_at")
    #attrs.delete("updated_at")
    return attrs
  end
end
