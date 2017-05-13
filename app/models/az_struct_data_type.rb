class AzStructDataType < AzBaseDataType

  attr_accessible :name, :type, :az_base_data_type_id, :az_collection_template_id, :created_at, :updated_at,
                  :copy_of, :owner_id, :seed, :az_base_project_id, :description, :status, :position, :tr_position

  #has_many :az_typed_pages, :foreign_key => 'az_base_data_type_id'
  #has_many :typed_pages, :through => :az_typed_pages, :source => 'az_page', :dependent => :destroy

  # TODO валидировать:
  # name - не пусто
  # az_base_data_type_id - всегда NULL
  # az_collection_template_id - всегда NULL

  has_many :az_variables, :dependent => :destroy, :order => :position
  belongs_to :az_base_project
  has_many :collections, :class_name=>'AzCollectionDataType', :foreign_key=>'az_base_data_type_id', :dependent => :destroy, :order => :name

  belongs_to :matrix, :class_name=>'AzStructDataType', :foreign_key=>'copy_of'

  #validates_presence_of   :az_base_project

  include Statuses

  def to_az_hash
    struct_hash = attributes
    #struct_hash["az_variables"] = az_variables.map{|v| v.to_az_hash}
    #struct_hash["collections"] = collections.map{|c| c.attributes}
    return struct_hash
  end

  def self.from_az_hash(attributes, project)
    struct = AzStructDataType.new(attributes)
    struct.az_base_project = project
    struct.owner_id = project.owner_id
    struct.copy_of = attributes['id']
    return struct
  end
  
  # TODO заменить везеде project_id на Project (когда это писалось это было необходимо для получения owner_id,
  # AzBaseProject.find(project_id) - это хуже чем передать объект)
  def make_copy_data_type(owner, project)
    dup = self.az_clone
    dup.owner = owner
    dup.az_base_project = project
    dup.copy_of = id
    dup.seed = false
    dup.save!

    self.az_variables.each do |variable|
      variable.make_copy_variable(owner, project, dup)
    end
    
    return dup
  end
 
  def get_operation_time(operation)
    time = 0
    az_variables.each do |var|
      if var.az_base_data_type.instance_of?(AzSimpleDataType)
        time += var.az_base_data_type.get_operation_time(operation)
      end
    end
    return time
  end

  def self.get_by_company(company)
    return find_all_by_owner_id(company.id, :conditions => { :az_base_project_id => nil }, :order => 'position')
  end

  def self.get_seeds
    return AzStructDataType.find_all_by_seed(true)
  end

  def get_crumbs_to_parent
    crumbs = [{:name => name, :type =>'Структура',  :url => {:controller => "az_struct_data_types", :action => 'edit', :id => self.id}, :parent => az_base_project}]
    if az_base_project
      crumbs.concat(az_base_project.get_crumbs_to_parent)
    end
    return crumbs
  end

  def move_up
    conditions = "position < #{self.position} "
    if self.az_base_project_id == nil
      conditions += " AND az_base_project_id is NULL"
    else
      conditions += " AND az_base_project_id=#{self.az_base_project_id}"
    end

    struct = AzStructDataType.find_last_by_owner_id(self.owner_id, :conditions => conditions, :order => 'position asc')

    if struct == nil
      return # Мы выше всех
    end

    struct.position, self.position = self.position, struct.position

    struct.save
    self.save
  end

  def move_down
    conditions = "position > #{self.position} "
    if self.az_base_project_id == nil
      conditions += " AND az_base_project_id is NULL"
    else
      conditions += " AND az_base_project_id=#{self.az_base_project_id}"
    end

    struct = AzStructDataType.find_last_by_owner_id(self.owner_id, :conditions => conditions, :order => 'position desc')

    if struct == nil
      return # Мы ниже всех
    end

    struct.position, self.position = self.position, struct.position

    struct.save
    self.save
  end

  def get_project

    if az_base_project == nil
      return nil
    end

    if az_base_project.class == AzProject
      return az_base_project
    end

    return az_base_project.parent_project
  end

  def self.get_model_name
    return "Структура"
  end

end
