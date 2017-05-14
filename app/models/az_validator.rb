class AzValidator < OwnedActiveRecord

  belongs_to :az_variable
  
  validates_presence_of :name
  validates_presence_of :description
  validates_presence_of :message
  
  def self.get_by_company(company)
    return find_all_by_owner_id(company.id, :conditions => { :az_variable_id => nil }, :order => 'name')
  end

  def self.get_seeds
    return find_all_by_seed(true)
  end

  def self.get_model_name
    return 'Валидатор'
  end

  def make_copy_validator(owner, variable)
    dup = self.clone
    dup.copy_of = id
    dup.owner = owner
    dup.az_variable = variable
    dup.seed = false
    dup.save!
    return dup
  end

  def self.from_az_hash(attributes, project, variable_ids_original_copy)
    validator = AzValidator.new(attributes)
    validator.copy_of = attributes['id']
    validator.owner = project.owner
    validator.az_variable_id = variable_ids_original_copy[attributes['az_variable_id']]
    return validator
  end

  def get_project
    if az_variable == nil
      return nil
    end
    return az_variable.get_project
  end

  def update_from_source(src)
    self.name = src.name
    self.description = src.description
    self.condition = src.condition
    self.message = src.message
    self.save
  end

  def sow(owner)
    result = nil

    if self.seed != true
      return result
    end

    validator_to_update = AzValidator.find(:first, :conditions => {:owner_id => owner.id, :copy_of => self.id})
    if validator_to_update == nil
      self.make_copy_validator(owner, nil)
      result = [self, 'copied']
    else
      validator_to_update.update_from_source(self)
      result = [self, 'updated']
    end

    return [result]
  end

  def self.update_from_seed(owner)
    result = []
    seeds = AzValidator.get_seeds
    seeds.each do |s|
      res = s.sow(owner)
      if res != nil
        result.concat(res)
      end
    end

    return result
  end

  def get_crumbs_to_parent
    crumbs = [{:name => name, :type => 'Валидатор', :parent => az_variable, :url => {:controller => "az_validators", :action => 'edit', :id => self.id}}]
    if az_variable
      crumbs.concat(az_variable.get_crumbs_to_parent)
    end
    return crumbs
  end

end
