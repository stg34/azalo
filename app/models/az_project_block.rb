class AzProjectBlock < AzBaseProject

  has_many :az_page_az_project_blocks, :foreign_key => :az_base_project_id, :dependent => :destroy
  has_many :pages_assigned_to, :through => :az_page_az_project_blocks, :source => :az_page

  belongs_to :matrix, :class_name=>'AzProjectBlock', :foreign_key=>'copy_of'
  belongs_to :parent_project, :class_name=>'AzProject', :foreign_key=>'parent_project_id'

  #has_one :az_store_item, :as => :item # TODO похоже это не работает если наш класс использует STI (а наш класс AzProjectBlock как раз и использует). Баг рельсов
  # в качестве решения проблемы используем функцию из AzBaseProject

  validates_presence_of :author_id

  def get_type_name
    "Компоненты"
  end


  def self.create(name, company_owner, author)
    component = AzProjectBlock.new
    component.name = name
    component.owner = company_owner
    component.author = author
    component.position = AzProjectBlock.get_last_position(company_owner) + 1

    ret = component.save
    if ret
      root = AzPage.new(:name =>'root', :title => 'root', :az_base_project_id => component.id, :owner_id => company_owner.id, :position => 1, :root => true)
      root.save!
      
    end

    return component
  end
  
#  def attach_copy_to_page(page_to_attach)
#    dup = make_copy(page_to_attach.owner)
#    #dup = find_copied_or_make_copy(page_to_attach)
#    pb = AzPageAzProjectBlock.new
#    pb.az_project_block = dup
#    pb.az_page = page_to_attach
#    #pb.az_project_block.parent_project = page_to_attach.az_base_project
#    pb.az_project_block.parent_project_id = page_to_attach.az_base_project_id
#    pb.save!
#    #dup.az_page = page_to_attach
#    dup.save!
#    return dup
#  end

  def make_copy(company, fix_ref = true)
    #puts company
    dup = super(company)
    #dup.parent_project = project
    #dup = find_copied_or_make_copy(page_to_attach)
    #pb = AzPageAzProjectBlock.new
    #pb.az_project_block = dup
    #pb.az_page = page_to_attach
    #pb.az_project_block.parent_project = page_to_attach.az_base_project
    #pb.az_project_block.parent_project_id = page_to_attach.az_base_project_id
    #pb.save!
    #dup.az_page = page_to_attach

    dup.parent_project_id = nil

    commons = [AzCommonsFunctionality,
               AzCommonsRequirementsHosting]

    commons.each do |cmc|
      cms = eval("#{cmc.to_s.underscore.pluralize}")
      cms.each do |cm|
        cm.make_copy_common(company, dup)
      end
    end

    dup.save!

    if fix_ref
      full_pages_list = dup.get_full_pages_list
      dup.fix_page_structure(full_pages_list)
      dup.fix_page_references(full_pages_list)
    end

    return dup
  end

  def find_copied(prj)
    project = AzProject.find(prj.id) 
    puts project.inspect
    project.get_project_block_list.each do |block|
      puts block.inspect
      if block.copy_of == self.id
        return block
      end
    end
    return nil
  end

  def find_copied_or_make_copy(page_to_attach)
    project = page_to_attach.get_project_over_block
    company = page_to_attach.owner
    copied_block = find_copied(project)
    if copied_block != nil
      return copied_block
    end
    return make_copy(company)
  end

  def attached_to_project?
    return pages_assigned_to.size != 0
  end

  def self.get_by_company(company)
    projects = find_all_by_owner_id(company.id, :order => 'position', :conditions => " parent_project_id is NULL ")
    return projects
    #return projects.select{ |p| p.pages_assigned_to.size == 0 }
  end

  def get_project_over_block
    if az_pages.size > 0
      return az_pages[0].get_project_over_block
    end
    return nil
  end

  def self.get_seeds
    return find_all_by_seed(true)
  end

  def get_crumbs_to_parent

    parent = nil
    if self.parent_project_id != nil
      parent = parent_project
    end

    crumbs = [{:name => name, :type => 'Компонент', :parent => parent, :url => {:controller => "az_project_blocks", :action => 'show', :id => self.id}}]
    if parent
      crumbs.concat(parent.get_crumbs_to_parent('components'))
    end

    puts '9'*10
    puts crumbs.inspect

    return crumbs

  end

  def self.get_model_name
    return "Компонент"
  end

  def get_root_pages
    root = AzPage.find(:first, :conditions => {:az_base_project_id => self.id, :root => true})
    child_links = root.child_links.sort{|a, b| a.position <=> b.position}
    children = child_links.collect{|l| l.az_page }
    return children
  end

  def get_all_data_types()
    all_data_types = AzBaseDataType.find_all_by_az_base_project_id(self.id)
    return all_data_types
  end

end

