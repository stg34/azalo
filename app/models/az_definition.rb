class AzDefinition < OwnedActiveRecord
  
  belongs_to :az_base_project

  belongs_to :matrix, :class_name=>'AzDefinition', :foreign_key=>'copy_of'
  
  validates_presence_of     :name
  validates_presence_of     :definition

  include Statuses

  def validate
    validate_owner_id_common('definition', 'Project')
  end

  def self.get_model_name
    return "Определние"
  end

  def before_create
    self.set_initial_position
  end

  def self.get_by_company(company)
    return AzDefinition.find_all_by_owner_id(company.id, :conditions => { :az_base_project_id => nil }, :order => :position)
  end

  def self.get_seeds
    return find_all_by_seed(true)
  end
  
  def self.from_az_hash(attributes, project)
      definition = AzDefinition.new(attributes)
      definition.az_base_project = project
      definition.owner = project.owner
      definition.copy_of = attributes['id']
      return definition
  end

  def make_copy_definition(owner, project)
    dup = self.clone
    dup.copy_of = id
    dup.owner = owner
    dup.az_base_project = project
    dup.seed = false
    dup.save!
    return dup
  end

  def update_from_source(src)
    self.name = src.name
    self.definition = src.definition
    self.save
  end

  def sow(owner)
    result = nil

    if self.seed != true
      return result
    end

    definition_to_update = AzDefinition.find(:first, :conditions => {:owner_id => owner.id, :copy_of => self.id})
    if definition_to_update == nil
      self.make_copy_definition(owner, nil)
      result = [self, 'copied']
    else
      definition_to_update.update_from_source(self)
      result = [self, 'updated']
    end

    return [result]
  end

  def self.update_from_seed(owner)
    result = []
    seeds = AzDefinition.get_seeds
    seeds.each do |s|
      res = s.sow(owner)
      if res != nil
        result.concat(res)
      end
    end

    return result
  end

  def move_up
    conditions = "position < #{self.position} "
    if self.az_base_project_id == nil
      conditions += " AND az_base_project_id is NULL"
    else
      conditions += " AND az_base_project_id=#{self.az_base_project_id}"
    end

    definition = AzDefinition.find_last_by_owner_id(self.owner_id, :conditions => conditions, :order => 'position asc')

    if definition == nil
      return # Мы выше всех
    end

    definition.position, self.position = self.position, definition.position

    definition.save
    self.save
  end

  def move_down
    conditions = "position > #{self.position} "
    if self.az_base_project_id == nil
      conditions += " AND az_base_project_id is NULL"
    else
      conditions += " AND az_base_project_id=#{self.az_base_project_id}"
    end

    definition = AzDefinition.find_last_by_owner_id(self.owner_id, :conditions => conditions, :order => 'position desc')

    if definition == nil
      return # Мы ниже всех
    end

    definition.position, self.position = self.position, definition.position

    definition.save
    self.save
  end

  def set_initial_position
    d = AzDefinition.find(:last, :order => :id)
    if d == nil
      self.position = 1
    else
      self.position = d.id + 1
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
