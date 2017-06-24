require 'rubygems'
#require 'paperclip'

class AzProject < AzBaseProject
  
  has_many :az_participants, :dependent => :destroy
  has_many :workers, :through => :az_participants, :source => 'az_employee', :conditions => {:disabled => false}
  has_many :az_activities, :foreign_key => :project_id, :dependent => :destroy

  #has_one :az_store_item, :as => :item # TODO похоже это не работает если наш класс использует STI (а наш класс AzProjectBlock как раз и использует). Баг рельсов
  # в качестве решения проблемы используем функцию ниже

  belongs_to :az_project_status
  belongs_to :owner, :class_name=>'AzCompany', :foreign_key=>'owner_id'

  belongs_to :matrix, :class_name=>'AzProject', :foreign_key=>'copy_of'

  # TODO Проверить, как у Redmine 30 - как в redmine, 6 - на ID проекта (project_name-12345)
  validates_length_of       :name, :maximum => 30-6
  validates_format_of       :name, :with => /^[\w\s\'\-\.]*$/i
  validates_numericality_of :layout_time

  def validate
    #puts "PROJECT VALIDATE '#{name}'..."
    #puts "public_access == #{public_access}"
    #puts "owner.private_project_quota_exceeded = #{owner.private_project_quota_exceeded}"
    if self.new_record?
      private_project_quota_exceeded_test = owner.private_project_quota_reached
    else
      private_project_quota_exceeded_test = owner.private_project_quota_exceeded
    end
    if public_access == false && private_project_quota_exceeded_test
      #puts 'PROJECT VALIDATE ERROR!!!'
      if is_active?
        errors.add_to_base('Превышено количество приватных проектов для вашего тарифа. Вы можете сделать проект публичным или сменить тариф на другой, с большим количеством приватных проектов.')
      end
    end
    if owner.get_locked
      errors.add_to_base('Company is locked')
    end
  end

#  def validate_status
#    active_projects = AzProject.get_active_by_company(self.owner)
#    active_projects_ids = active_projects.collect{|p| p.id}
#    puts "=----------------------===========================---------------------------"
#    puts active_projects_ids.inspect
#
#    project_in_active = active_projects_ids.include?(self.id)
#
#    puts project_in_active
#    puts "=----------------------===========================---------------------------"
#
#    if active_projects.size > self.owner.az_tariff.quota_active_projects
#      errors.add_to_base("Превышено количество активных проектов!")
#    elsif active_projects.size == self.owner.az_tariff.quota_active_projects && !project_in_active
#      errors.add_to_base("Превышено количество активных проектов!")
#    end
#
#  end

  #def build_from_az_hash(project_hash)
  #  AzProject.new(project_hash)
  #end

  def self.create(name, company_owner, author, public_access = true)
    project = AzProject.new
    project.name = name
    project.layout_time = 1
    project.owner = company_owner
    project.author = author
    project.public_access = public_access

    last_project = AzProject.find(:last, :order => :position, :conditions => {:owner_id => company_owner.id })

    if last_project == nil || last_project.position == nil
      position = 0
    else
      position = last_project.position + 1
    end

    project.position = position
    
    ret = project.save

    if ret
      ##################
      # Создание партисипантов. По умолчанию все - автор проекта
      project.set_default_participants(author)

      root = AzPage.new(:name =>'root', :title => 'root', :az_base_project_id => project.id, :owner_id => company_owner.id, :position => 1, :root => true)
      root.save!
      page = AzPage.new(:name =>'Главная', :title => 'Главная', :az_base_project_id => project.id, :owner_id => company_owner.id, :position => 1)
      page.parents = [root]
      page.save!
      page = AzPage.new(:name =>'Вход в админку', :title => 'Вход в админку', :az_base_project_id => project.id, :owner_id => company_owner.id, :page_type => AzPage::Page_admin, :position => 2)
      page.parents = [root]
      page.save!

      commons = [AzCommonsCommon,
                 AzCommonsAcceptanceCondition,
                 AzCommonsContentCreation,
                 AzCommonsPurposeExploitation,
                 AzCommonsPurposeFunctional,
                 AzCommonsRequirementsHosting,
                 AzCommonsRequirementsReliability]

      commons.each do |cmc|
        common = cmc.get_default
        if common != nil
          cm = cmc.find(common.make_copy_common(company_owner, @project))
          eval("project.#{cmc.to_s.tableize} << cm")
        end
      end

    end

    return project
  end

#  def self.get_project_list_by_company_and_user(company, user)
#    list = AzProject.find(:all, :conditions => {:owner_id => company.id})
#    return list
#  end

  def self.create_rm_project(project, name, author)
    return project
  end

  def get_type_name
    "Проект"
  end

  def can_be_copied
    #company = self.owner
    return true
  end

  def can_be_managed
    if public_access == false && owner.private_project_quota_exceeded
      return false
    end
    return true
  end

  def can_user_create(user)
    return true
  end

  def can_user_read(user)
    return true
  end

  def can_user_update(user)
    return true
  end

  def can_user_delete(user)
    return true
  end
 
  def get_project_block_list(full_pages_list = nil)
    return components
  end

  def self.get_rm_project_identifier(project)
    return "project-" + project.id.to_s
  end

  def self.get_az_project_identifier(identifier)
    return Integer(identifier.split('-')[1])
  end

  def get_tasks_time(task_types)
    return {:tasks_time => 0, :tasks_time_done => 0 }
  end

  def set_percent_complete(pc)
    self.percent_complete = pc
    save(false)
  end

  def make_copy(owner)
    dup = super(owner)
    dup.created_at = Time.now
    commons = [AzCommonsCommon,
               AzCommonsAcceptanceCondition,
               AzCommonsContentCreation,
               AzCommonsPurposeExploitation,
               AzCommonsPurposeFunctional,
               AzCommonsFunctionality,
               AzCommonsRequirementsHosting,
               AzCommonsRequirementsReliability]

    commons.each do |cmc|
      cms = eval("#{cmc.to_s.underscore.pluralize}")
      cms.each do |cm|
        cm.make_copy_common(owner, dup)
      end
    end

    components.each do |component|
      component_dup = component.make_copy(dup.owner, false)
      dup.components << component_dup
    end

    full_pages_list = dup.get_full_pages_list
    dup.fix_page_structure(full_pages_list)
    dup.fix_page_references(full_pages_list)

    if ENV["RAILS_ENV"] != 'test'
      AzProject.create_rm_project(dup, name, owner.ceo)
    end

    dup.set_default_participants(owner.ceo)

    return dup
  end
 
  def self.get_seeds
    return AzProject.find_all_by_seed(true)
  end

  def set_default_participants(user)
    project = self
    # Создание партисипантов. По умолчанию все - автор проекта
    employee = project.owner.get_employee_by_user(user)
    AzParticipant.create(:az_project => project, :az_employee => employee, :owner => project.owner) if employee
  end

  def update_from_source(src)
    # TODO реализовать обновление проекта
    #self.name = src.name
    #self.description = src.description
    #self.comment = src.comment
    #self.save!
  end

  def sow(owner)
    result = nil

    if self.seed != true
      return result
    end

    project_to_update = AzProject.find(:first, :conditions => {:owner_id => owner.id, :copy_of => self.id})
    if project_to_update == nil
      self.make_copy(owner)
      result = [self, 'copied']
    else
      #common_to_update.update_from_source(self)
      # TODO реализовать обновление проекта
      result = [self, 'skeeped']
    end

    return [result]
  end

  def self.update_from_seed(owner)
    result = []
    seeds = AzProject.get_seeds
    seeds.each do |s|
      res = s.sow(owner)
      if res != nil
        result.concat(res)
      end
    end
    return result
  end

  def get_crumbs_to_parent(show_type = nil)
    if show_type
      crumbs = [{:name => name, :type => 'Проект', :parent => nil, :url => {:controller => "az_projects", :action => 'show', :id => self.id, :show_type => show_type}}]
    else
      crumbs = [{:name => name, :type => 'Проект', :parent => nil, :url => {:controller => "az_projects", :action => 'show', :id => self.id}}]
    end
    
    return crumbs
  end

  def self.get_active_by_company(company)
    projects = find_all_by_owner_id(company.id, :joins => [:az_project_status], :order => 'position', :conditions => "az_project_statuses.state = #{AzProjectStatus::PS_enabled}")
    return projects
  end

  def is_active?
    return self.az_project_status.state == AzProjectStatus::PS_enabled
  end

  def is_paricipant?(employee)
    pp = az_participants.select{|p| p.az_employee.id == employee.id }
    return pp.size > 0
  end

  def ar_project_participant_user_ids

    

    #participant_user_ids = az_participants.collect{|p| p.az_employee.az_user.id}
    ceo_id = self.owner.ceo_id

    #return []

    participant_user_ids = workers.collect{|w| w.az_user.id}

    participant_user_ids << ceo_id
    return participant_user_ids
  end

  def ar_admin_ids
    return [1]
  end

  def self.get_model_name
    return "Проект"
  end

  def get_self
    # Нужно в обсервере
    return self
  end

  def get_all_data_types()
    all_data_types = AzBaseDataType.find_all_by_az_base_project_id(self.id)
    self.components.each do |block|
      all_data_types.concat(AzBaseDataType.find_all_by_az_base_project_id(block.id))
    end
    return all_data_types
  end

  def self.get_latest_projects(limit = 5)
    find(:all, :order => 'created_at desc', :limit => limit)
  end

  def self.get_latest_public_projects(limit = 5)
    find(:all, :conditions => {:public_access => true}, :order => 'created_at desc', :limit => limit)
  end

  def self.get_popular_projects(limit = 5)
    find_by_sql("SELECT *, count(*) as cnt  FROM az_base_projects WHERE (type = 'AzProject' and copy_of is not NULL) GROUP BY copy_of order by cnt desc limit #{limit}")
  end

  def self.get_piblic_projects(page)
    return paginate(:all, :conditions => {:public_access => true}, :order => 'created_at desc', :page => page, :per_page => 20)
  end

  def update_status(new_status)
    
    if new_status.state == AzProjectStatus::PS_disabled
      self.az_project_status = new_status
      return save
    end

    #active_projects = AzProject.get_active_by_company(self.owner)
    #if active_projects.size >= owner.az_tariff.quota_active_projects
    #  return false
    #end

    self.az_project_status = new_status
    return save
  end

end
