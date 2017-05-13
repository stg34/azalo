class AzCollectionDataType < AzBaseDataType

  attr_accessible :name, :type, :az_base_data_type_id, :az_collection_template_id, :created_at, :updated_at, :copy_of,
                  :owner_id, :seed, :az_base_project_id, :description, :status, :position, :tr_position, :az_base_data_type, :az_collection_template

  # TODO валидировать:
  # name - не пусто
  # az_base_data_type_id - не пусто
  # az_collection_template_id - не пусто

  belongs_to :az_base_data_type
  belongs_to :az_collection_template
  belongs_to :az_base_project
  belongs_to :matrix, :class_name => 'AzCollectionDataType', :foreign_key=>'copy_of'

  has_many :az_typed_pages, :foreign_key => 'az_base_data_type_id'
  has_many :typed_pages, :through => :az_typed_pages, :source => 'az_page', :dependent => :destroy

  #has_many :typed_pages, :through => :az_typed_pages, :source => 'az_page', :dependent => :destroy

  validates_presence_of :az_base_data_type
  validates_presence_of :az_collection_template
  validates_presence_of :az_base_project

  def self.get_model_name
    return "Коллекция"
  end

  def self.from_az_hash(attributes, project, struct_ids_original_copy)
    collection = AzCollectionDataType.new(attributes)
    collection.az_base_project = project
    collection.owner_id = project.owner_id
    collection.copy_of = attributes['id']
    base_data_type = AzBaseDataType.find(:first, :conditions => {:id => collection.az_base_data_type_id})
    if base_data_type.type == 'AzStructDataType'
      collection.az_base_data_type_id = struct_ids_original_copy[collection.az_base_data_type.id]
    end

    return collection
  end

  def make_copy_data_type(owner, project)
    dup = self.az_clone
    dup.copy_of = id
    dup.owner = owner
    dup.az_base_project = project

    td_id = az_base_data_type.find_copied_or_make_copy(owner, project)
    dup.az_base_data_type = AzBaseDataType.find(td_id)

    dup.save!

    return dup
  end

  def get_operation_time(operation)
    return az_base_data_type.get_operation_time(operation)
  end

  def get_crumbs_to_parent
    crumbs = [{:name => name, :type =>'Коллекция',  :url => {:controller => "az_collection_data_types", :action => 'edit', :id => self.id}, :parent => az_base_data_type}]
    if az_base_data_type
      crumbs.concat(az_base_data_type.get_crumbs_to_parent)
    end
    return crumbs
  end

  def get_project
    if az_base_data_type == nil
      return nil
    end
    return az_base_data_type.get_project
  end

end

