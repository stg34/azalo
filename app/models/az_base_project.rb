require 'rubygems'
require 'paperclip'

class AzBaseProject < OwnedActiveRecord
  Max_quality = 18.3

  #filter_access_to :all #TODO Fix me

  attr_accessible :author_id,
                  :az_project_status_id,
                  :cache,
                  :copy_of,
                  :created_at,
                  :customer,
                  :deleting,
                  :disk_usage,
                  :explorable,
                  :favicon_content_type,
                  :favicon_file_name,
                  :favicon_file_size,
                  :favicon_updated_at,
                  :forkable,
                  # :id,
                  :layout_time,
                  :name,
                  :owner_id,
                  :parent_project_id,
                  :percent_complete,
                  :position,
                  :public_access,
                  :quality_correction,
                  :rm_id,
                  :seed,
                  :type,
                  :updated_at

  has_many    :az_pages,   :order=>:position, :dependent => :destroy#, :conditions => {:parent_id => nil}

  #has_many    :az_base_projects_az_definitions
  has_many    :az_definitions, :dependent => :destroy, :order=>:position
  #has_many    :az_definitions, :through => :az_base_projects_az_definitions
  has_many    :az_guest_links, :dependent => :destroy
  has_many    :az_base_data_types, :dependent => :destroy, :order=>:position
  has_many    :az_struct_data_types, :order=>:position
  has_many    :az_collection_data_types, :order=>:position

  has_many :az_commons,                            :foreign_key => :az_base_project_id, :dependent => :destroy, :order => :position
  has_many :az_commons_commons,                    :foreign_key => :az_base_project_id, :dependent => :destroy, :order => :position
  has_many :az_commons_acceptance_conditions,      :foreign_key => :az_base_project_id, :dependent => :destroy, :order => :position
  has_many :az_commons_content_creations,          :foreign_key => :az_base_project_id, :dependent => :destroy, :order => :position
  has_many :az_commons_purpose_exploitations,      :foreign_key => :az_base_project_id, :dependent => :destroy, :order => :position
  has_many :az_commons_purpose_functionals,        :foreign_key => :az_base_project_id, :dependent => :destroy, :order => :position
  has_many :az_commons_functionalities,            :foreign_key => :az_base_project_id, :dependent => :destroy, :order => :position
  has_many :az_commons_requirements_hostings,      :foreign_key => :az_base_project_id, :dependent => :destroy, :order => :position
  has_many :az_commons_requirements_reliabilities, :foreign_key => :az_base_project_id, :dependent => :destroy, :order => :position

  has_many :components, :class_name => 'AzProjectBlock', :foreign_key => 'parent_project_id', :dependent => :destroy, :order => :name

  has_one :stat, :class_name => 'AzBaseProjectStat', :order => 'created_at desc'
  has_many :stats, :class_name => 'AzBaseProjectStat', :dependent => :destroy
  #has_one :az_base_project_stat

  belongs_to  :author, :foreign_key => 'author_id', :class_name => 'AzUser'

  has_attached_file :favicon, :styles => {:x16x16 => "16x16"}

  validates_presence_of     :name
  validates_presence_of     :author

  def store_item
    # Обход бага рельсов. см. описание в AzProject и AzProjectBlock
    return AzStoreItem.find(:first, :conditions => {:item_id => self.id, :item_type => self.class.to_s})
  end

  def get_type_name
    "Базовый проект"
  end

  def can_user_create(user)
    # return user == owner
    # return user is not guest
    return true
  end

  def can_user_read(user)
    return true
    #return user == owner
  end

  def can_user_update(user)
    return true
    #return user == owner || workers.include?(user)
  end

  def can_user_delete(user)
    return true
    #return user == owner
  end

  def can_be_forked(to_company)
    if to_company.get_locked
      return false
    end

    # Мы сами себе копируем сколько угодно
    if to_company.id == self.owner.id
      return true
    end

    # Другие толко если проект публичный
    return self.public_access
  end

  def self.get_by_company(company)
    projects = find_all_by_owner_id(company.id, :order => 'position')
    return projects
  end

  def self.get_last_position(owner)
    last_project = self.find(:last, owner.id, :conditions => ["owner_id = #{owner.id}"], :order => 'position')
    if last_project == nil || last_project.position == nil
      return 0
    else
      return last_project.position
    end
  end

  def move_up

    if self.position == nil
      self.position = self.id
      self.save
    end

    if self.parent_project_id == nil
      parent_project_id_condition = "parent_project_id is null"
    else
      parent_project_id_condition = "parent_project_id = #{self.parent_project_id}"
    end

    project = self.class.find_last_by_owner_id(self.owner_id, :conditions => [" #{parent_project_id_condition} and position <  #{self.position}" ], :order => 'position')

    if project == nil
      return
    end

    project.position, self.position = self.position, project.position

    project.save
    self.save
  end

  def move_down
    if self.position == nil
      self.position = self.id
      self.save
    end

    if self.parent_project_id == nil
      parent_project_id_condition = "parent_project_id is null"
    else
      parent_project_id_condition = "parent_project_id = #{self.parent_project_id}"
    end

    #project = self.class.find_last_by_owner_id(self.owner_id, :conditions => [ "position >  #{self.position}", { :parent_project_id => self.parent_project_id} ], :order => 'position desc')
    project = self.class.find_last_by_owner_id(self.owner_id, :conditions => [" #{parent_project_id_condition} and position >  #{self.position}" ], :order => 'position desc')

    if project == nil
      return
    end

    project.position, self.position = self.position, project.position

    project.save
    self.save
  end

  def update_disk_usage(all_pages)
    return
    #########################################################################################################################################
    # TODO обновить с помощью запросов
    # Сумма картинок проекта:
    page_ids = all_pages.collect{|page| page.id}
    page_ids = page_ids.join(',')
    #puts page_ids
    sql_images = "select sum(image_file_size) as s from az_images where az_design_id in (SELECT id FROM `az_designs` WHERE az_page_id in (#{page_ids}))"
    sql_design_sources = "select sum(source_file_size) as s from az_design_sources where az_design_id in (SELECT id FROM `az_designs` WHERE az_page_id in (#{page_ids}))"
    images_size = ActiveRecord::Base.connection.select_one(sql_images)
    sources_size = ActiveRecord::Base.connection.select_one(sql_design_sources)
    images_size = Integer(images_size['s'])
    sources_size = Integer(sources_size['s'])

    #puts images_size
    #puts sources_size

    self.disk_usage = sources_size + images_size
    self.save!

    return 
  end

  def get_full_pages_list(page_type = nil)
    pages1 = get_full_pages_list_internal1(self, page_type)
    return pages1
  end

  def get_full_pages_list_internal1(project, page_type = nil, direct = false)

    if page_type
      pages1 = AzPage.find(:all, :conditions => {:az_base_project_id => project.id, :page_type => page_type})
    else
      pages1 = AzPage.find(:all, :conditions => {:az_base_project_id => project.id})
    end

    puts "project: #{project.name} (#{project.id}), pages: #{pages1.size}"

    blocks = AzProjectBlock.find(:all, :conditions => {:parent_project_id => project.id})
    blocks.each do |block|
      pages1.concat(get_full_pages_list_internal1(block, page_type, direct))
    end
    return pages1
  end

  def get_full_pages_list_internal(pages, page_type = nil, direct = false)
    pages1 = []
    pages.each do |page|
      pages1.concat(get_full_pages_list_internal(page.children, page_type))

      unless direct
        page.attached_blocks.each do |block|
          pages1.concat(block.get_full_pages_list(page_type))
        end
      end

    end
    return pages1.concat(pages.select{ |p| ((p.get_page_type == page_type) || (page_type == nil)) })
  end

  def get_data_types
    all_pages = get_full_pages_list
    
    types = []
    all_pages.each do |page|
      page.types.each do |type|
        types << type

        if type.instance_of?(AzCollectionDataType)
          types << type.az_base_data_type
        end
      end
    end
    #puts types.uniq.inspect
    types.sort!{|a, b| a.name <=> b.name}
    return types.uniq
  end


  def get_definitions
    return AzDefinition.find(:all, :conditions => { :owner_id => self.owner.id})
  end

  def get_all_definitions
    dfn = []
    dfn.concat(az_definitions)
    components.each do |c|
      dfn.concat(c.az_definitions)
    end
    return dfn.sort!{|a, b| a.position <=> b.position}
  end

  # def get_all_commons(common_class)
  #   cms = []
  #   cms.concat(eval("self.#{common_class.to_s.underscore.pluralize}"))
  #   components.each do |c|
  #     cms.concat(eval("self.#{common_class.to_s.underscore.pluralize}"))
  #   end
  #   return cms
  # end
  
  def move_definition_down_tr(dfn_id)
    dfns = get_all_definitions

    dfn_id = Integer(dfn_id)

    if dfns.size < 2
      return
    end

    idx = dfns.index{|d| d.id == dfn_id}
    if idx == nil || idx == dfns.size - 1
      # not found or last element
      return
    end

    dfns[idx].position, dfns[idx+1].position = dfns[idx+1].position, dfns[idx].position
    dfns[idx].save
    dfns[idx+1].save
  end
  
  def move_definition_up_tr(dfn_id)
    dfns = get_all_definitions

    dfn_id = Integer(dfn_id)

    if dfns.size < 2
      return
    end

    idx = dfns.index{|d| d.id == dfn_id}
    if idx == nil || idx == 0
      # not found or first element
      return
    end

    dfns[idx].position, dfns[idx-1].position = dfns[idx-1].position, dfns[idx].position
    dfns[idx].save
    dfns[idx-1].save
  end

  #############
  def get_all_commons(common_class_name)
    #puts common_class_name.tableize
    
    component_ids = components.collect{|c| c.id}
    component_ids << self.id
    #puts component_ids.inspect
    common_class = eval(common_class_name)
    commons = common_class.find(:all, :conditions => {:az_base_project_id => component_ids}, :order => :position)
    return commons

    #prj_commons = eval("self.#{common_class_name.tableize}")
    #commons.concat(prj_commons)
    #commons = eval("self.#{common_class_name.tableize}")
    #components.each do |c|
    #  cmp_commons = eval("c.#{common_class_name.tableize}")
    #  commons.concat(cmp_commons)
    #end
    #return commons.sort!{|a, b| a.position <=> b.position}
  end

  def move_common_down_tr(cmn_id)
    cmn_id = Integer(cmn_id)
    cmn = AzCommon.find(cmn_id)
    if cmn == nil
      return
    end

    cmns = get_all_commons(cmn[:type])

    if cmns.size < 2
      return
    end

    idx = cmns.index{|c| c.id == cmn_id}
    if idx == nil || idx == cmns.size - 1
      # not found or last element
      return
    end

    cmns[idx].position, cmns[idx+1].position = cmns[idx+1].position, cmns[idx].position
    cmns[idx].save
    cmns[idx+1].save
  end

  def move_common_up_tr(cmn_id)
    cmn_id = Integer(cmn_id)
    cmn = AzCommon.find(cmn_id)
    if cmn == nil
      return
    end

    cmns = get_all_commons(cmn[:type])

    if cmns.size < 2
      return
    end

    idx = cmns.index{|c| c.id == cmn_id}
    if idx == nil || idx == 0
      # not found or first element
      return
    end

    cmns[idx].position, cmns[idx-1].position = cmns[idx-1].position, cmns[idx].position
    cmns[idx].save
    cmns[idx-1].save
  end
  ############
  

  def change_definitions(defenition_ids)
    project_definition_ids = az_definitions.collect{ |pd| pd.id}
    to_add = defenition_ids - project_definition_ids
    to_remove = project_definition_ids - defenition_ids

    definitions_to_add = AzDefinition.find(to_add)
    definitions_to_remove = AzDefinition.find(to_remove)

    az_base_projects_az_definitions
    definitions_to_add.each do |dfn|
      pd = AzBaseProjectsAzDefinition.new
      pd.owner_id = self.owner_id
      pd.az_base_project_id = self.id
      pd.az_definition_id = dfn.id
      pd.save!
    end
    #az_definitions << definitions_to_add
    az_definitions.delete(definitions_to_remove)
  end

  def fix_page_structure(full_pages_list)
    pages_copied = full_pages_list
    root_page = self.get_root_page

    matrix_index = {}
    pages_copied.each do |page|
      matrix_index[page.copy_of] = page
    end

    pages_copied.each do |page|
      page.original.parents.each do |o_parent|

        if matrix_index[o_parent.id]
          puts "page: #{page.id} adding parent: #{matrix_index[o_parent.id].id}"
          if !page.parents.include?(matrix_index[o_parent.id])
            page.parents << matrix_index[o_parent.id]
          end
        end
      end

      # Если страница выпала из структуры дерева, принуджительно привязываем её к корню сайта.
      if page.parents.size == 0 && !page.root
        page.parents << root_page
      end
      #page.save!
    end
    
  end

  def fix_page_references(full_pages_list)
    pages_copied = full_pages_list
    references = [:az_design_double_page_id, :az_functionality_double_page_id]
    matrix_index = {}
    pages_copied.each do |page|
      matrix_index[page.copy_of] = page
    end
    references.each do |reference|
      pages_copied.each do |page|
        if page[reference]
          page[reference] = matrix_index[page[reference]].id
        end
        page.save!
      end
    end
  end

  def get_disk_usage
    return disk_usage
  end


  def to_az_hash(attrs = {})
    
    self.class.benchmark 'az_base_project' do
      if self.class == AzProject
        attrs['az_project'] = attributes
      elsif  self.class == AzProjectBlock
        attrs['az_project_blocks'] ||= []
        attrs['az_project_blocks'] << attributes
      end
    end
    #attrs.delete("id")
    #attrs.delete("created_at")
    #attrs.delete("updated_at")
    #attrs.delete('type')
    self.class.benchmark 'az_definitions' do
      attrs['az_definitions'] ||= []
      az_definitions.each{|d| attrs['az_definitions'] << d.attributes}
    end

    self.class.benchmark 'az_commons' do
      attrs['az_commons'] ||= []
      az_commons.each{|c| attrs['az_commons'] << c.attributes}
    end

    variable_ids = []
    self.class.benchmark "az_struct_data_types" do
      attrs['az_struct_data_types'] ||= []
      az_struct_data_types.each do |struct|
        attrs['az_struct_data_types'] << struct.attributes
        variable_ids.concat(struct.az_variable_ids)
      end
    end

    self.class.benchmark "az_variables" do
      attrs['az_variables'] ||= []
      variables = AzVariable.find(variable_ids)
      variables.each{ |variable| attrs['az_variables'] << variable.attributes }
    end

    self.class.benchmark "az_validators" do
      attrs["az_validators"] ||= []
      validators = AzValidator.find(:all, :conditions => {:az_variable_id => variable_ids})
      validators.each do |validator|
        attrs["az_validators"] << validator.attributes
      end
    end

    self.class.benchmark "az_collection_data_types" do
      attrs['az_collection_data_types'] ||= []
      az_collection_data_types.each{ |collection| attrs['az_collection_data_types'] << collection.attributes }
    end
    
    page_ids = []
    self.class.benchmark('az_pages') do
      attrs['az_pages'] ||= []
      pages = AzPage.find_all_by_az_base_project_id(id)
      pages.each do |p|
        page_ids << p.id
        attrs['az_pages'] << p.attributes
      end
    end

    self.class.benchmark 'az_page_links' do
      attrs['az_page_links'] ||= []
      links = AzPageAzPage.find(:all, :conditions => {:page_id => page_ids})
      links.each do |link|
        attrs['az_page_links'] << link.attributes
      end
    end
    
    design_ids = []
    self.class.benchmark 'az_designs' do
      attrs['az_designs'] ||= []
      designs = AzDesign.find(:all, :conditions => {:az_page_id => page_ids})
      designs.each do |design|
        design_ids << design.id
        attrs["az_designs"] << design.attributes
      end
    end

    typed_page_ids = []
    self.class.benchmark 'az_typed_pages' do
      attrs['az_typed_pages'] ||= []
      typed_pages = AzTypedPage.find(:all, :conditions => {:az_page_id => page_ids})
      typed_pages.each do |typed_page|
        typed_page_ids << typed_page.id
        attrs["az_typed_pages"] << typed_page.attributes
      end
    end

    self.class.benchmark 'az_allowed_operations' do
      attrs['az_allowed_operations'] ||= []
      allowed_operations = AzAllowedOperation.find(:all, :conditions => {:az_typed_page_id => typed_page_ids})
      allowed_operations.each do |allowed_operation|
        attrs["az_allowed_operations"] << allowed_operation.attributes
      end
    end

    self.class.benchmark "az_images" do
      attrs["az_images"] ||= []
      images = AzImage.find(:all, :conditions => {:az_design_id => design_ids})
      images.each{ |image| attrs["az_images"] << image.attributes}
    end

    self.class.benchmark "az_design_sources" do
      attrs["az_design_sources"] ||= []
      design_sources = AzDesignSource.find(:all, :conditions => {:az_design_id => design_ids})
      design_sources.each do |design_source|
        attrs["az_design_sources"] << design_source.attributes
      end
    end

    components.each{|c| c.to_az_hash(attrs)}

      #self.class.benchmark("components") {attrs["components"] = components.map{|c| c.to_az_hash}}
  #    project_hash["data_types"] = get_all_data_types.map{|dt| dt.to_az_hash}
    return attrs
  end
  
  def self.from_az_hash(attributes, project, company)
    project_class = eval(attributes['type'])
    base_project = project_class.new(attributes)
    base_project.copy_of = attributes['id']
    base_project.owner = company
    base_project.parent_project_id = project.id if project
    return base_project
  end


  def self.build_from_az_hash(project_hash, company, local_copy = true)

    project_original_copy = {}
    page_ids_original_copy = {}
    struct_ids_original_copy = {}
    collection_ids_original_copy = {}
    variable_ids_original_copy = {}
    design_ids_original_copy = {}
    typed_page_ids_original_copy = {}

    prj = new(project_hash['az_project'])
    prj.id = nil
    prj.seed = false

    if local_copy
      original_prj = find(project_hash['az_project']['id'])
      prj.favicon = original_prj.favicon
    end
    prj.owner = company
    prj.save!
    project_original_copy[project_hash['az_project']['id']] = prj.id

    components_attributes = project_hash['az_project_blocks'] || []
    components_attributes.each do |component_attributes|
      component = from_az_hash(component_attributes, prj, company)
      #TEST component.owner = company
      component.save!
      project_original_copy[component_attributes['id']] = component.id
    end

    pages_attributes = project_hash['az_pages']
    pages_attributes.each do |page_attributes|
      page = AzPage.from_az_hash(page_attributes, project_original_copy, company)
      #TEST page.owner = company
      page.copying = true
      ret = page.save!
      page_ids_original_copy[page.copy_of] = page.id
    end

    # fixing functionality and design sources
    pages_attributes.each do |page_attributes|
      page = AzPage.find(page_ids_original_copy[page_attributes['id']])
      page.az_functionality_double_page_id = page_ids_original_copy[page_attributes['az_functionality_double_page_id']]
      page.az_design_double_page_id = page_ids_original_copy[page_attributes['az_design_double_page_id']]
      page.copying = true
      ret = page.save!
    end
    # fixing functionality and design sources - END

    page_links_attributes = project_hash['az_page_links']
    page_links_attributes.each do |page_link_attributes|
      page_link = AzPageAzPage.from_az_hash(page_link_attributes, page_ids_original_copy)
      #---page.owner = company
      page_link.save!
    end

    definitions_attributes = project_hash['az_definitions']
    definitions_attributes.each do |definition_attributes|
      definition = AzDefinition.from_az_hash(definition_attributes, prj)
      #TEST definition.owner = company
      definition.save!
    end

    structs_attributes = project_hash['az_struct_data_types']
    structs_attributes.each do |struct_attributes|
      struct = AzStructDataType.from_az_hash(struct_attributes, prj)
      #TEST struct.owner = company
      struct.save!
      struct_ids_original_copy[struct.copy_of] = struct.id
    end

    collections_attributes = project_hash['az_collection_data_types']
    collections_attributes.each do |collection_attributes|
      collection = AzCollectionDataType.from_az_hash(collection_attributes, prj, struct_ids_original_copy)
      #TEST collection.owner = company
      collection.save!
      collection_ids_original_copy[collection.copy_of] = collection.id
    end

    variables_attributes = project_hash['az_variables']
    variables_attributes.each do |variable_attributes|
      variable = AzVariable.from_az_hash(variable_attributes, prj, struct_ids_original_copy, collection_ids_original_copy)
      variable_ids_original_copy[variable.copy_of] = variable.id
      #TEST variable.owner = company
      variable.save!
    end

    validators_attributes = project_hash['az_validators']
    validators_attributes.each do |validator_attributes|
      validator = AzValidator.from_az_hash(validator_attributes, prj, variable_ids_original_copy)
      #TEST variable.owner = company
      validator.save!
    end

    commons_attributes = project_hash["az_commons"]
    commons_attributes.each do |common_attributes|
      common = AzCommon.from_az_hash(common_attributes, prj)
      #TEST common.owner = company
      common.save!
    end

    designs_attributes = project_hash["az_designs"]
    designs_attributes.each do |design_attributes|
      design = AzDesign.from_az_hash(design_attributes, page_ids_original_copy, company)
      #TSET design.owner = company
      design.save!
      design_ids_original_copy[design.copy_of] = design.id
    end

    images_attributes = project_hash["az_images"]
    images_attributes.each do |image_attributes|
      image = AzImage.from_az_hash(image_attributes, prj.owner, design_ids_original_copy)
      #TEST image.owner = company
      image.save! if image
    end

    design_sources_attributes = project_hash["az_design_sources"]
    design_sources_attributes.each do |design_source_attributes|
      design_source = AzDesignSource.from_az_hash(design_source_attributes, design_ids_original_copy, company)
      #TEST design_source.owner = company
      design_source.save! if design_source
    end

    typed_pages_attributes = project_hash["az_typed_pages"]
    typed_pages_attributes.each do |typed_page_attributes|
      typed_page = AzTypedPage.from_az_hash(typed_page_attributes, page_ids_original_copy, company)
      #TEST typed_page.owner = company
      typed_page.save!
      typed_page_ids_original_copy[typed_page_attributes['id']] = typed_page.id
    end

    allowed_operations_attributes = project_hash["az_allowed_operations"]
    allowed_operations_attributes.each do |allowed_operation_attributes|
      allowed_operation = AzAllowedOperation.from_az_hash(allowed_operation_attributes, typed_page_ids_original_copy, company)
      #TEST allowed_operation.owner = company
      allowed_operation.save!
    end

    return prj.reload
  end

  def fork(company)
    return nil unless can_be_forked(company)
    return AzProject.build_from_az_hash(project.to_az_hash, company)
  end
  
  def make_copy(company)
    puts "PROJECT MAKE_COPY #{name} #{id} new_owner_id = #{company.id}"
    a = Time.now
    #puts " ...................................................................."
    b = Time.now; puts a-b; a=b;
    #b = Time.now; puts "-> 1. " + (b-a).to_s; a=b;

    dup = self.az_clone
    dup.owner = company
    dup.copy_of = id
    dup.seed = false
    # dup.favicon = favicon   # TODO Fix me. Restore favicon copying
    dup.percent_complete = 0
    dup.position = self.class.get_last_position(owner) + 1

    dup.save!

    #b = Time.now; puts "-> 2. " + (b-a).to_s; a=b;

    az_pages.each do |page|
      page.make_copy_page(dup)
    end

    #b = Time.now; puts "-> 3. " + (b-a).to_s; a=b;

    az_definitions.each do |df|
      dup.az_definitions << df.make_copy_definition(company, dup)
    end

    #b = Time.now; puts "-> 4. " + (b-a).to_s; a=b;
    return dup.reload
  end

  def add_definition(definition)
    definition.make_copy_definition(self.owner, self)
  end

  def remove_definition(definition)
    definition.destroy
  end

  def get_crumbs_from_tr

    if self.instance_of?(AzProject)
      type = 'ТЗ проекта'
      controller = "az_project"
    else
      type = 'ТЗ компонента'
      controller = "az_project_blocks"
    end

    crumbs = [{:name => name, :type => type, :parent => self, :url => {:controller => controller, :action => 'show_tr', :id => self.id}}]

    crumbs.concat(self.get_crumbs_to_parent)

    return crumbs

  end

  def get_crumbs_from_project_edit

    if self.instance_of?(AzProject)
      type = 'Свойства проекта'
      controller = "az_project"
    else
      type = 'Свойства компонента'
      controller = "az_project_blocks"
    end

    crumbs = [{:name => name, :type => type, :parent => self, :url => {:controller => controller, :action => 'show', :id => self.id}}]

    crumbs.concat(self.get_crumbs_to_parent)

    return crumbs

  end


  def tr_sort_admin_pages
    tr_sort_admin_pages_internal(az_pages, AzPage::Page_admin)
  end

  def tr_sort_public_pages
    tr_sort_user_pages_internal(az_pages)
  end

#  def tr_sort_user_pages_internal(pages, count = 0)
#    pages = pages.select{ |p| p.get_page_type == AzPage::Page_user }
#    pages.sort!{|a, b| a.position <=> b.position }
#    pages.each do |page|
#      puts "#{page.name} #{page.id} #{page.page_type} #{count}"
#      puts page.page_type == AzPage::Page_user
#      count += 1
#      page.tr_position = count
#      page.save
#
#      page.attached_blocks.each do |block|
#        count = block.tr_sort_user_pages_internal(block.az_pages, count)
#      end
#
#      count = tr_sort_user_pages_internal(page.children, count)
#
#    end
#    return count
#  end
#
#  def tr_sort_admin_pages_internal(pages, count = 0)
#    pages = pages.select{ |p| p.get_page_type == AzPage::Page_admin }
#    pages.sort!{|a, b| a.position <=> b.position }
#    pages.each do |page|
#      #puts "#{page.name} #{page.id} #{page.page_type} #{count}"
#      #puts page.page_type == AzPage::Page_admin
#      count += 1
#      page.tr_position = count
#      page.save
#
#      count = tr_sort_admin_pages_internal(page.children, count)
#
#      page.attached_blocks.each do |block|
#        count = block.tr_sort_admin_pages_internal(block.az_pages, count)
#      end
#
#      blocks = get_project_block_list
#      blocks.each do |block|
#        count = block.tr_sort_admin_pages_internal(block.az_pages, count)
#      end
#
#    end
#    return count
#  end

  def get_root_pages
    

  end

  def get_root_page
    AzPage.find(:first, :conditions => {:az_base_project_id => id, :root => true})
  end

  def self.count_new_this_week
    return count_by_sql("SELECT count(*) FROM `az_base_projects` WHERE created_at > date_add(now(), interval -7 day) and type='AzProject' and (copy_of is NULL or copy_of <>355)")
  end

  def self.find_last_public_projects
    find(:all, :conditions => {:public_access => true}, :order => "created_at desc", :limit => 3)
  end

  def self.find_last_public_active_projects(args = {})
    page = args[:page]
    p page
    p args
    p args.has_key?(:page)
    sql = "SELECT *, count(*) as cnt
           FROM az_activities
           RIGHT JOIN az_base_projects ON az_base_projects.id = az_activities.project_id
           WHERE (az_activities.created_at >DATE_ADD(NOW(), INTERVAL -7 DAY)) and az_base_projects.type='AzProject' AND az_base_projects.public_access=1 AND explorable = true
           GROUP BY project_id order by cnt desc"
           
    if args.has_key?(:page)
      return paginate_by_sql(sql, :page => page, :per_page => 20)
    end
    return find_by_sql(sql + " LIMIT 5")
  end

  def self.find_public_noteworthy_projects(page)
    quality_treshold = 3.0/5.0 * Max_quality #4 из 5

    sql = "SELECT az_base_projects.*, s1.id as s1id, s1.quality, s1.az_base_project_id FROM az_base_project_stats s1
           RIGHT JOIN az_base_projects ON s1.az_base_project_id = az_base_projects.id
           WHERE
           quality > #{quality_treshold}
           AND
           public_access = true
           AND
           explorable = true
           AND
           (s1.id = (SELECT max(s2.id) FROM az_base_project_stats s2 WHERE s1.az_base_project_id = s2.az_base_project_id))
           ORDER BY az_base_projects.created_at DESC"


    return paginate_by_sql(sql, :page => page, :per_page => 20)
  end

  def self.find_last_public_noteworthy_projects
    #find(:all, :conditions => ['az_base_project_stats.quality > 10'], :order => "az_base_project_stats.quality desc", :limit => 5, :joins => :stat)

    quality_treshold = 15
    interval_seconds_from_now = 7*24*3600
    sql = "
          select * from az_base_projects where type='AzProject' and id in (SELECT distinct az_base_project_id FROM az_base_project_stats outer_stats
          WHERE
            quality >= #{quality_treshold}
          AND
            public_access = true
          AND
            explorable = true
          AND
            created_at >  DATE_SUB(NOW(), INTERVAL #{interval_seconds_from_now} SECOND)
          AND # Все значения качества меньше порога для даты меньшей, чем нас интересует
            (#{quality_treshold} >=
              (SELECT MAX(inner_stats.quality)
              FROM az_base_project_stats inner_stats
              WHERE inner_stats.created_at < outer_stats.created_at
              AND outer_stats.az_base_project_id = inner_stats.az_base_project_id)
          OR (SELECT MAX(inner_stats.quality)       #или таковых значений вообще нет
              FROM az_base_project_stats inner_stats
              WHERE inner_stats.created_at < outer_stats.created_at
              AND outer_stats.az_base_project_id = inner_stats.az_base_project_id) IS NULL
          )
          AND # Последнее значение больше порога
            #{quality_treshold} <
              (SELECT inner_stats.quality
              FROM az_base_project_stats inner_stats
              WHERE outer_stats.az_base_project_id = inner_stats.az_base_project_id
             ORDER BY inner_stats.created_at DESC  LIMIT 1)
          ORDER BY az_base_project_id)"

    return find_by_sql(sql)

    #SELECT az_base_projects.* FROM az_base_projects INNER JOIN az_base_project_stats ON az_base_project_stats.az_base_project_id = az_base_projects.id WHERE (az_base_project_stats.quality > 10) AND ( (az_base_projects.type = 'AzProject' ) ) ORDER BY az_base_project_stats.quality desc LIMIT 5

    #find(:all, :conditions => ['az_base_project_stats.quality > 10 and public_access = true'], :order => "az_base_project_stats.quality desc", :limit => 5, :joins => :stat)
  end

  def get_all_components
    all_components = []
    all_components.concat(components)
    get_count_components_internal(all_components)
    return all_components
  end

  def get_count_components_internal(all_components)
    all_components.each do |c|
      all_components.concat(get_count_components_internal(c.components))
    end
    return all_components
  end

  def designs_images_words_in_pages_internal
    words_num = 0
    pages_num = az_pages.size
    az_pages.each do |page|
      words_num += page.description.split.size if page.description
    end

    designs = AzDesign.find(:all, :conditions => {:az_page_id => az_page_ids})
    design_ids = designs.collect{|design| design.id}

    images_num = AzImage.count(:conditions => {:az_design_id => design_ids})
    puts "images_num = #{images_num}"
    design_sources_num = AzDesignSource.count(:conditions => {:az_design_id => design_ids})

    all_components = get_all_components
    all_components.each do |component|
      component_design_sources_num, component_images_num, component_words_num, component_pages_num = component.designs_images_words_in_pages_internal
      design_sources_num += component_design_sources_num
      images_num += component_images_num
      puts "+= images_num = #{images_num}"
      words_num += component_words_num
      pages_num += component_pages_num
    end
    pages_num -= 1 # вычитаем root проекта
    pages_num -= all_components.size # вычитаем root-ы компонентов
    pages_num = 0 if pages_num < 0
    return design_sources_num, images_num, words_num, pages_num
  end

  
  Signifact_words_in_definition = 5
  Signifact_words_in_common = 5
  def update_stats(force = false)
    stat = AzBaseProjectStat.new

    stat.commons_words_num = 0
    common_classes = AzCommon.get_child_classes
    common_classes.each do |common_class|
      commons = get_all_commons(common_class.to_s)
      count = commons.count{|d| d.description.split.size > Signifact_words_in_common}  
      short_common_name = "#{common_class.to_s.underscore}"['az_'.length..-1]
      commons.each do |common|
        stat.commons_words_num += common.description.split.size 
      end
      #puts(short_common_name + '_num')
      stat[(short_common_name + '_num').to_sym] = count
    end

    # Подсчет количества значимых компонентов в проекте
    all_components = get_all_components
    statistcally_significant_components_count = all_components.count{|c| c.az_pages.size > 1}

    stat.structs_num = az_struct_data_types.size
    all_components.each do |component|
      stat.structs_num += component.az_struct_data_types.size
    end

    # Подсчет количества значимых определений в проекте
    stat.definitions_words_num = 0
    all_definitions = get_all_definitions
    statistcally_significant_definitions_count = all_definitions.count{|d| d.definition.split.size > Signifact_words_in_definition}

    stat.definitions_words_num = 0
    all_definitions.each do |definition|
      stat.definitions_words_num += definition.definition.split.size 
    end
    
    design_sources_num, images_num, pages_words_num, pages_num = designs_images_words_in_pages_internal
    
    stat.images_num = images_num
    stat.design_sources_num = design_sources_num
    
    stat.components_num = statistcally_significant_components_count
    stat.definitions_num = statistcally_significant_definitions_count
    stat.pages_num = pages_num
    stat.pages_words_num = pages_words_num

    stat.words_num = stat.definitions_words_num + stat.commons_words_num + stat.pages_words_num

    stat.quality = stat.get_quality
    stat.save
    self.stats << stat
    return stat
  end

  def get_rating

    if stat == nil
      return 0
    end
    
    return 5 if 5.0*stat.quality/Max_quality > 4.5
    return 4 if 5.0*stat.quality/Max_quality > 3.5
    return 3 if 5.0*stat.quality/Max_quality > 2.5
    return 2 if 5.0*stat.quality/Max_quality > 1.5
    return 1 if 5.0*stat.quality/Max_quality > 0.5
    return 0
  end

end
