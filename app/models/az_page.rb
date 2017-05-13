require 'statuses'

class AzPage < OwnedActiveRecord

  attr_accessible :name, :title, :az_base_project_id, :owner_id, :position, :root, :page_type, :parent_id, :estimated_time,
                  :created_at, :updated_at, :az_design_double_page_id, :az_functionality_double_page_id, :copy_of,
                  :description, :status, :tr_position, :embedded, :az_base_project, :owner, :parents

  # TODO Провалидировать, что owner_id у страниц :design_source и :functionality_source корректный

  Page_user = 0
  Page_admin = 1

  include Statuses

  #has_many :az_project_blocks, :dependent => :destroy

  #has_many :az_page_az_project_blocks, :dependent => :destroy
  #has_many :attached_blocks, :through => :az_page_az_project_blocks, :source => :az_project_block
  
  #has_many :az_page_az_pages, :foreign_key => :page_id
  
  belongs_to :az_base_project

  #belongs_to :parent_page,   :class_name => 'AzPage', :foreign_key => 'parent_id'
  belongs_to :parent,   :class_name => 'AzPage', :foreign_key => 'parent_id'

  has_many :child_links,  :foreign_key => :parent_page_id,  :class_name => 'AzPageAzPage', :dependent => :destroy
  has_many :parent_links, :foreign_key => :page_id,         :class_name => 'AzPageAzPage', :dependent => :destroy
  has_many :parents,  :through => :parent_links, :source => :az_parent_page
  has_many :children, :through => :child_links,  :source => :az_page

  has_many :az_typed_pages, :dependent => :destroy
  has_many :types, :through => :az_typed_pages, :source => 'az_base_data_type'

  has_many :az_designs, :dependent => :destroy
  #accepts_nested_attributes_for :az_designs, :reject_if => proc{ |attributes| AzPage.reject_designs(attributes)}, :allow_destroy => true

  belongs_to :design_source,   :class_name => 'AzPage', :foreign_key => 'az_design_double_page_id'
  has_many :design_recipients, :class_name => 'AzPage', :foreign_key => 'az_design_double_page_id', :dependent => :nullify

  belongs_to :original,   :class_name => 'AzPage', :foreign_key => 'copy_of'

  belongs_to :functionality_source,   :class_name => 'AzPage', :foreign_key => 'az_functionality_double_page_id'
  has_many :functionality_recipients, :class_name => 'AzPage', :foreign_key => 'az_functionality_double_page_id', :dependent => :nullify

  validates_presence_of :name
  validates_presence_of :az_base_project
  validates_presence_of :page_type

  attr_accessor :copying

  validates_uniqueness_of :root, :scope=>:az_base_project_id, :if => :root

  validate :validate1
  def validate1
    validate_owner_id_common('page', 'Project')
    validate_embedded_attribute if parents.size > 0
    validate_design_source
    validate_root_attribute
  end
  
  def validate_design_source
    if root && design_source
      errors.add(:base, "Root page cannot has design")
    end
  end

  def validate_embedded_attribute
    if embedded && !can_be_embedded?
      errors.add(:base, "This page cannot be embedded")
    end
  end

  def validate_root_attribute
    #puts "validate_root_attribute ----------------------------------------------------------------------------------"
    #puts parents.size
    #puts root
    #puts "validate_root_attribute ----------------------------------------------------------------------------------"
    if !copying
      if(!root && parents.size == 0)
        #puts "MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM"
        #puts self.inspect
        #puts "MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM"
        errors.add(:base, "Only root page can has no parents")
      end
    end
  end
  
  # TODO При удалении страницы, необходио установить в NULL functionality_source и design_source у design_recipients и functionality_recipients

  attr_accessor :belongs_to_project
  #attr_accessor :position_foo

  def belongs_to_project
    id = self.get_project_over_block.id
    #puts "**********************************************************************"
    #puts id.inspect
    #puts "**********************************************************************"
    return id
  end

  def has_public_access
    prj = self.get_project_over_block

    return prj.public_access
  end

  def self.get_model_name
    return 'Страница'
  end

#  def self.reject_designs(attributes)
#
#    puts "-------------------- hello from reject_designs"
#    puts attributes.inspect
#    puts attributes['description'].blank?
#
#    img_blank = true;
#    if attributes["az_images_attributes"] != nil
#      img_blank = attributes["az_images_attributes"]["0"]["image"].blank?
#      puts attributes["az_images_attributes"]["0"]["image"].blank?
#    end
#
#    page_blank = attributes['description'].blank?
#
#    puts "-------------------- hello from reject_designs = " + (page_blank && img_blank).to_s
#    return page_blank && img_blank
#  end


  def is_page_mine
    return true
  end

  def is_full_double
    if functionality_source != nil && design_source != nil
      return get_page_functionality_source.id == get_page_design_source.id
    end
    
    return false
  end

  def get_page_design_source
    if design_source == nil
      return self
    end
    design_source.get_page_design_source
  end

  def get_page_functionality_source
    if functionality_source == nil
      return self
    end
    functionality_source.get_page_functionality_source
  end

  def is_page_in_design_sources(dst_page)
    page = self
    if page.id == dst_page.id
      return true
    end
    while page.design_source != nil
      page = page.design_source
      if page.id == dst_page.id
        return true
      end
    end
    return false
  end

  # TODO merge is_page_in_design_sources and is_page()_in_design_sources()
  def is_page_in_functionality_sources(dst_page)
    page = self
    if page.id == dst_page.id
      return true
    end
    while page.functionality_source != nil
      page = page.functionality_source
      if page.id == dst_page.id
        return true
      end
    end
    return false
  end

  def is_my_child(page)
    if page.id == self.id
      return true
    end
    get_children.each do |p|
      if page.id == p.id
        return true
      end
      if p.is_my_child(page)
        return true
      end
    end
    return false
  end

  def get_children(page_type = nil)
    children1 = children.select{ |c| ((c.get_page_type == page_type) || (page_type == nil)) }
    #children1.concat(get_children_through_block(page_type))
    return children1
  end

  def get_children1(page_type = nil)
    children1 = children.select{ |c| ((c.get_page_type == page_type) || (page_type == nil)) }
    embedded, children1 = children1.partition{|p| p.embedded == true }
    embedded.each do |e|
      children1.concat(e.get_children1(page_type))
    end
    #children1.concat(embedded.collect)
    #children1.concat(get_children_through_block(page_type))
    return children1
  end

  def get_descendants(page_type = nil)
    return get_descendants_internal(children, page_type)
  end

  def get_descendants_internal(pages, page_type = nil)
    pages1 = []
    pages.each do |page|
      pages1.concat(get_descendants_internal(page.children, page_type = nil))
      #page.attached_blocks.each do |block|
      #  pages1.concat(block.get_full_pages_list(page_type))
      #end
    end
    return pages1.concat(pages)
  end
  
  def get_children_through_block(page_type = nil)
    children = []
    attached_blocks.each do |block|
      block.az_pages.each do |page|
        if (page.get_page_type == page_type || page_type == nil)
          page.children.each do |c|
            children << c
          end
        end
      end
    end
    return children
  end

  
#  def attach_snippet(snippet)
#    snippet.az_pages.each do |snippet_page|
#      pg = AzPage.new
#      pg.name = snippet_page.name
#      pg.az_base_project_id = self.az_base_project_id
#      pg.parent_id = self.id
#      pg.save!
#      attach_pages_from_snippet(pg, snippet_page)
#    end
#    return self.save!
#  end
#
#  def attach_pages_from_snippet(parent, snippet_page)
#    snippet_page.get_children.each do |page|
#      pg = AzPage.new
#      pg.name = page.name
#      pg.az_base_project_id = parent.az_base_project_id
#      pg.parent_id = parent.id
#      pg.save!
#      attach_pages_from_snippet(page, pg)
#    end
#  end

  def get_designs
    if self.id == 51836
      puts self.id
    end
    p = get_real_design_source
    embedded_pages = p.get_embedded_pages1
    
    if embedded_pages.size > 0
      design_ids = az_designs.collect{|d| d.id}
      
      
      embedded_pages.each do |page|
        #if page.page_type == Page_user
          if (page.is_embedded)
            design_ids.concat(page.get_designs.collect{|d| d.id})
            #designs = page.get_designs
          end
        #end
      end
      
      #puts "----------------------------------------------------------------------"
      #puts design_ids.inspect
      #puts "----------------------------------------------------------------------"
      designs = AzDesign.find(design_ids)
      return designs
    else
      return p.az_designs
    end
  end

  def get_main_design
    p = get_real_design_source
    
    if p.get_designs.size > 0
      return p.get_designs[0]
    end
    return no_az_design
  end

  def get_all_designs
    p = get_real_design_source

    if p.get_designs.size > 0
      return p.get_designs
    end
    return [no_az_design]
  end

  def get_all_designs_count
    p = get_real_design_source
    return p.get_designs.size
  end

  def get_uploaded_design_sources_count
    p = get_real_design_source
    dc = 0
    p.get_designs.each do |design|
      if design.az_design_source && design.az_design_source.source_file_name != nil
        dc += 1
      end
    end
    
    return dc
  end

  def has_designs_without_images
    p = get_real_design_source

    p.get_designs.each do |design|
      return true if !design.has_az_images
    end
    return false
  end

  def no_az_design
    # return
    design = AzDesign.new#(:description => 'Нет дизайна')
    design.description = 'Нет дизайна'
    design
  end

  def get_project
    return self.az_base_project
  end

  def get_project_over_block
    prj = az_base_project
    if !prj.instance_of?(AzProjectBlock)
      return prj
    end
    if prj.parent_project
      prj = prj.parent_project
    end
    return prj
  end

  def page_in_assigned_block?
    if get_project.instance_of?(AzProject)
      return false
    end

    if get_project.instance_of?(AzProjectBlock)
      return get_project.attached_to_project?
    end
    return false
  end

  def get_page_over_block
    prj = self.get_project
    if !prj.instance_of?(AzProjectBlock)
      return nil
    end
    
    return prj.az_page
    
  end

#  def added_and_removed_page_types(types_before, types_after)
#    return [types_after - types_before, types_before - types_after]
#  end
  
#  def add_page_type(page_types)
#    return
#    #puts "add virtual page " + page_types.inspect
#    page_types.each do |pt|
#      #puts "page types >>> " + pt.name
#      pt.az_variables.each do |var|
#        #puts "variable >>> " + var.name
#        if var.az_base_data_type.is_page_type
#          #puts "variable type >>> " + var.az_base_data_type.name
#          #puts var.az_base_data_type.inspect
#          #puts "add new page"
#          pg = AzPage.new
#          pg.name = var.az_base_data_type.name
#          pg.az_base_project_id = self.get_project.id
#          pg.parent_id = self.id
#          pg.save!
#        end
#        if var.az_base_data_type['type'] == 'AzCollectionDataType' && var.az_base_data_type.az_base_data_type.is_page_type
#          #puts "template variable type >>> " + var.az_base_data_type.az_base_data_type.name
#          #puts "template. add new page"
#          pg = AzPage.new
#          pg.name = var.az_base_data_type.az_base_data_type.name
#          pg.az_base_project_id = self.get_project.id
#          pg.parent_id = self.id
#          pg.save!
#        end
#      end
#    end
#
#  end

#  def remove_page_type(page_types)
#    return
#    #puts "remove virtual page " + page_types.inspect
#  end

  def belongs_to_block_belongs_to_page?
    
    #if self.az_base_project.class == AzProjectBlock
    #  puts "---------------------------------==========================================="
    #  puts self.az_base_project.class
    #  puts self.az_base_project.az_page_az_project_blocks.size
    #  puts self.attached_blocks.size
    #  puts self.id
    #  puts "---------------------------------==========================================="
    #end
    return self.az_base_project.class == AzProjectBlock && self.az_base_project.az_page_az_project_blocks.size
  end

  def to_az_hash
    attrs = attributes
    return attrs
  end

  def self.from_az_hash(attributes, project_original_copy, owner)
    page = AzPage.new(attributes)
    page.copy_of = attributes['id']
    page.owner = owner
    page.az_base_project_id = project_original_copy[attributes['az_base_project_id']]
    #puts "++++++++++++++++++++++++++++++++ #{project_original_copy[attributes['az_base_project_id']]} ++++++++++++++ #{attributes['az_base_project_id']}"
    return page
  end

  def make_copy_page(project, copy_designs = true)
    puts "PAGE MAKE_COPY new_owner_id = #{project.owner.id}"
    # TODO нужно сделать транзакцию на всю функцию

    a = Time.now
    b = Time.now; puts a-b; a=b;

    # dup = self.clone
    dup = self.az_clone
    # dup = AzPage.new
    # self.attributes.each_pair{|attr, val| dup.send(attr+'=', val)}
    # dup.id = nil

    dup.copying = true
    
    dup.owner = project.owner
    dup.az_base_project = project

    dup.copy_of = id

    #puts dup.inspect

    if copy_designs
      az_designs.each do |d|
        dup.az_designs << d.make_copy_design(dup.az_base_project, dup)
      end
    end

    az_typed_pages.each do |tpg|
      t = tpg.az_base_data_type
      tp = AzTypedPage.new
      tp.az_page = dup
      tp.copy_of = tpg.id
      project_to_search_copy = project
      tp.az_base_data_type = t.find_copied_or_make_copy(dup.owner, project_to_search_copy)
      tp.owner = dup.owner
      tpg.az_allowed_operations.each do |aop|
        new_aop = AzAllowedOperation.new(:az_typed_page => tp, 
                                         :az_operation => aop.az_operation, 
                                         :owner_id => dup.owner.id,
                                         :copy_of => aop.id)
        new_aop.save!
      end
      tp.save!
    end
    dup.save!

    b = Time.now; puts a-b; a=b;
    return dup
  end

  def get_operations_total_time
    total = 0

    az_typed_pages.each do |tp|
      total += tp.get_time_for_operations
    end

    get_embedded_pages1.each do |page|
      total += page.get_operations_total_time
    end

    return total
  end

  def get_layout_time
    if design_source != nil
      return 0.0
    end
    return get_project_over_block.layout_time
  end

  def self.get_page_types
    return {Page_user => 'Юзерка',  Page_admin => 'Админка'}
  end

  def get_page_type(force = false)
    page = self
    if force
      while page.parent != nil
        page = page.parent
      end
    end
    return page.page_type
  end


  def update_page_type(page_type)
    return
  end



  def get_embedded_links
    return self.child_links.select{|l| l.az_page}.select{|l| l.az_page.embedded}
  end

  def get_embedded_pages1
    return self.get_embedded_links.collect{|l| l.az_page}
  end

  def get_not_embedded_pages1
    return self.get_not_embedded_links.collect{|l| l.az_page}
  end

  def get_not_embedded_links
    return self.child_links.select{|l| l.az_page}.reject{|l| l.az_page.embedded}
  end

  def is_embedded
    # Страница в блоке, страница корневая и блок назначен странице в проекте
    # embedded - вмурованный 
    #return get_project.instance_of?(AzProjectBlock) && parent == nil && get_project.attached_to_project?
    return embedded
  end

  def get_max_children_position

    max = 0
    if children.size > 0
      max = children[0].position
      children.each do |p|
        if max < p.position
          max = p.position
        end
      end
    end
    return max
  end

  def move_up
    pages = []
    pg = nil
    if parent != nil
      pages = parent.children.sort{|a, b| b.position <=> a.position }
    else
      pages = get_project.az_pages
    end

    #pages = parent.children.sort{|a, b| b.position <=> a.position }
    poss = pages.collect{|p| p.position}
    if poss.size != poss.uniq.size
      #puts "REORDERING"
      n = 0
      pages.each do |p|
        p.position = n
        n += 1
        p.save!
      end
    end

    pages.each do |p|
      if p.position < self.position
        pg = p
        break
      end
    end

    if pg != nil
      pg.position, self.position = self.position, pg.position
      save!
      pg.save!
    end
    
  end

  def move_down
    pages = []
    pg = nil
    if parent != nil
      pages = parent.children.sort{|a, b| a.position <=> b.position }
    else
      pages = get_project.az_pages
    end

    poss = pages.collect{|p| p.position}
    if poss.size != poss.uniq.size
      #puts "REORDERING"
      n = 0
      pages.each do |p|
        p.position = n
        n += 1
        p.save!
      end
    end

    pages.each do |p|
      if p.position > self.position
        pg = p
        break
      end
    end

    if pg != nil
      pg.position, self.position = self.position, pg.position
      save!
      pg.save!
    end
    
  end

  def get_real_design_source
    p = self
    while p.design_source != nil
      p = p.design_source
    end
    return p
  end

  def page_type?(page_type)
    if page_type == nil
      return true
    end
    return self.page_type == page_type
  end

  def has_root_in_parents
    return parents.to_a.count{|p| p.root && az_base_project.id == p.az_base_project.id} > 0
  end

  def can_be_embedded?
    return az_base_project.class == AzProjectBlock && has_root_in_parents
  end

  def can_be_set_page_type?
    return has_root_in_parents
  end

  def get_tr_texts

    texts = []
  
    no_type = AzNoDataType.new
    no_operation = AzOperation.new
    no_operation.name = 'no operation'
    no_operation.id = -1
    
    az_typed_pages.each do |tp|

      texts_and_operations = []
      dtt = tp.az_base_data_type.data_type_type
      tp.az_allowed_operations.each do |aop|
        if dtt
          tr_texts = AzTrText.find(:all, :conditions => {:owner_id => owner.id, :az_operation_id => aop.az_operation.id, :data_type => dtt[:id]})
          texts_and_operations << {:operation => aop.az_operation, :tr_texts => tr_texts}
        end

      end

      tr_texts = AzTrText.find(:all, :conditions => {:owner_id => owner.id, :az_operation_id => nil, :data_type => dtt[:id]})
      texts_and_operations << {:operation => no_operation, :tr_texts => tr_texts}
      texts << {:type => tp.az_base_data_type, :texts_by_operation => texts_and_operations}

    end

    texts_and_operations = []
    tr_texts = AzTrText.find(:all, :conditions => {:owner_id => owner.id, :az_operation_id => nil, :data_type => nil})
    texts_and_operations << {:operation => no_operation, :tr_texts => tr_texts}
    texts << {:type => no_type, :texts_by_operation => texts_and_operations}

    #texts.each do |text|
    #  puts text.inspect
    #end
    
    return texts
  end

end
