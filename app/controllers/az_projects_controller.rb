class AzProjectsController < AzBaseProjectsController

  Common_classes = [[AzCommonsCommon,                   0, 'separator'],
                      [AzCommonsContentCreation,         30, ''],
                      [AzCommonsAcceptanceCondition,     40, 'separator'],
                      [AzCommonsPurposeExploitation,     10, ''],
                      [AzCommonsPurposeFunctional,       20, 'separator'],
                      [AzCommonsRequirementsHosting,     50, ''],
                      [AzCommonsRequirementsReliability, 60, 'separator']]

  def project_forbidden_url
    projects_url
  end


  layout "main"

  filter_access_to :index_user, :new, :create, :guest_show, :index
  filter_access_to :all, :attribute_check => true
  #filter_access_to :show
  
  # GET /projects
  # GET /projects.xml
  def index

    @projects = AzProject.paginate(:all, :conditions => {:copy_of => nil}, :order => 'id desc', :page => params[:page])

    @title = 'Все сайты'

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @projects }
    end
  end

  # GET /projects
  # GET /projects.xml
  def index_user
    @my_companies = current_user.my_works

    @projects = {}
    @my_companies.each do |company|
      @projects[company] = AzProject.get_by_company(company)
    end

    @employees = AzEmployee.get_by_companies(@my_companies)

    status_freeze = AzProjectStatus.find(8) #TODO Магическое число 8!!!

    #@my_companies.each do |company|
      #q = company.az_tariff.quota_active_projects
      #qempl = company.az_tariff.quota_employees
      #active_count = 0
      #enabled_employee_count = 0

      #@projects[company].reverse.each do |prj|
        #if prj.az_project_status.state == AzProjectStatus::PS_enabled
        #  active_count += 1
        #end

        #if active_count > q
        #  prj.az_project_status = status_freeze
        #  prj.save
        #end
      #end

      #@employees[company].reverse.each do |empl|
      #  if !empl.disabled
      #    enabled_employee_count += 1
      #  end

      #  if enabled_employee_count > qempl
      #    if company.ceo.id == empl.az_user.id
      #      next
      #    end
      #    empl.disabled = true
      #    empl.save
      #  end
      #end

    #end

    @title = 'Сайты'

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @projects }
    end
  end

  # GET /projects/1
  # GET /projects/1.xml
#  def show_tr
#
#    @project = AzProject.find(params[:id])
#
#    az_pages_options =  {:except => ['updated_at', 'created_at']}
#    xml_inlude = { :include => { :az_pages => az_pages_options },  :except => ['updated_at', 'created_at'] }
#
#    respond_to do |format|
#      if @project.can_user_read(current_user)
#        format.html { render :template => 'az_base_projects/show'}
#        format.xml  { render :xml => @project.to_xml(xml_inlude) }
#      else
#        format.html { redirect_to(project_forbidden_url) }
#        format.xml  { render :xml => "ooooops" }
#      end
#    end
#  end

  # GET /projects/1
  # GET /projects/1.xml
  def guest_show

    begin
      # При заходе яндекс бота, выпадаем по не ясным причинам
      AzGuestLink.remove_expired_links
    rescue
    end

    if session[:project_show_type] == nil
      session[:project_show_type] = :design
    end

    @show_type = session[:project_show_type]

    guest_link = AzGuestLink.find_by_hash(params[:hash_str])

    project = nil
    if guest_link != nil && guest_link.az_project != nil
      project = guest_link.az_project

      if guest_link.az_user == nil
        self.current_user = AzUser.authenticate_by_guest_link(params[:hash_str])
        guest_link.az_user = self.current_user
        guest_link.save(false)
      else
        self.current_user = guest_link.az_user
      end
      #ApplicationController.set_guest_project_ids(project.id)
      #prepare_show_data(project.id)
      #@project.set_percent_complete(@project_complete_percent)
    end

    respond_to do |format|
      if project == nil
        format.html { render(:text => 'А вот нет такого проекта!') }
      else
        if guest_link.url != nil && guest_link.url != ''
          format.html { redirect_to(guest_link.url) }
        else
          format.html { redirect_to(project) }
        end
      end
      #format.xml  { render :xml => @project.to_xml(xml_inlude) }
    end
  end

  def show
    @show_type = show_type_str_to_sym(params[:show_type])

    @project = AzProject.find(params[:id])
    @project.update_stats

    #f = File.open(Rails.root + "tmp/#{@project.id}.yaml", "w")
    #project_hash = @project.to_az_hash
    #puts "========================================================================================================="
    #f.write(project_hash.to_yaml)
    #f.close
    #
    #f2 = File.open(Rails.root + "tmp/#{@project.id}.xml")
    #project_xml = f2.read
    #project_hash = Hash.from_xml(project_xml)
    ##pp project_hash
    #f2.close
    ##project = AzProject.build_from_az_hash(project_hash["hash"])
    ##pp project
    #
    #puts "========================================================================================================="

    if !(@project.cache && fragment_exist?(:controller => params[:controller], :action => params[:action], :id => params[:id], :show_type => params[:show_type]))
      prepare_show_data(params[:id])
      @project.set_percent_complete(@project_complete_percent)
      @project_tree = PrTree.build(@project)
      @project_commons = commons_by_classes(@project)
      @common_classes = Common_classes
    end

    az_pages_options =  {:except => ['updated_at', 'created_at']}
    xml_inlude = { :include => { :az_pages => az_pages_options },  :except => ['updated_at', 'created_at'] }

    respond_to do |format|
        #if current_user == nil
        #  format.html { render 'plain_show'}
        #else
          #format.html { render 'show'}
          #putsd "&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&"
          if session[:collapsed_project_panel] == nil
            project_panel_collapsed = true
            #putsd "project_panel_collapsed = true"
          else
            project_panel_collapsed = !(session[:collapsed_project_panel][@project.id] == true)
          end

          format.html { render :template => 'az_base_projects/show1', :locals => { :project_panel_collapsed => project_panel_collapsed }}
        #end
        format.xml  { render :xml => @project.to_xml(xml_inlude) }
    end
  end

  

#  def show1
#
#    if session[:project_show_type] == nil
#      session[:project_show_type] = :design
#    end
#    @show_type = session[:project_show_type]
#
#    prepare_show_data(params[:id])
#
#    @project.set_percent_complete(@project_complete_percent)
#
#    @project_commons = commons_by_classes(@project)
#
#    @common_classes = Common_classes
#
#    az_pages_options =  {:except => ['updated_at', 'created_at']}
#    xml_inlude = { :include => { :az_pages => az_pages_options },  :except => ['updated_at', 'created_at'] }
#
#    respond_to do |format|
#        #if current_user == nil
#        #  format.html { render 'plain_show'}
#        #else
#          #format.html { render 'show'}
#          putsd "&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&"
#          if session[:collapsed_project_panel] == nil
#            project_panel_collapsed = true
#            putsd "project_panel_collapsed = true"
#          else
#            project_panel_collapsed = !(session[:collapsed_project_panel][@project.id] == true)
#          end
#
#          format.html { render :template => 'az_base_projects/show', :locals => { :project_panel_collapsed => project_panel_collapsed }}
#        #end
#        format.xml  { render :xml => @project.to_xml(xml_inlude) }
#    end
#  end

  def prepare_show_data(project_id)
    a = Time.now
    start = a
    puts "?????????????????????????????????????????????????????????????????????????????????"
    b = Time.now; puts a-b; a=b;

    if @show_type == nil
      @show_type = :design
    end
    b = Time.now; puts "1. " + (b-a).to_s; a=b;

    @project = AzProject.find(project_id)

    b = Time.now; puts "3. " + (b-a).to_s; a=b;


    @all_pages = @project.get_full_pages_list

    b = Time.now; puts "3a. " + (b-a).to_s; a=b;

    # TODO Сделать нормальные права доступа или нормально обновлять используемое проектом место.
    #if current_user && !current_user.roles.include?(:visitor)
    #  @project.update_disk_usage(@all_pages)
    #end

    b = Time.now; puts "4. " + (b-a).to_s; a=b;
    
    @employees_can_be_added = @project.owner.get_employees

    b = Time.now; puts "5. " + (b-a).to_s; a=b;
    
    @project_blocks = AzProjectBlock.get_by_company(@project.owner)

    b = Time.now; puts "5a. " + (b-a).to_s; a=b;

    #@block_list = @project.get_project_block_list(@all_pages)
    @block_list = @project.components

    b = Time.now; puts "6. " + (b-a).to_s; a=b;

    @all_data_types = @project.get_all_data_types
    
    b = Time.now; puts "8. " + (b-a).to_s; a=b;

    @data_type_list_with_collections = AzPageType.page_types_with_collections(@all_data_types)

    b = Time.now; puts "9. " + (b-a).to_s; a=b;

    #puts "@all_pages.size = " + @all_pages.size.to_s
    b = Time.now; puts "11. " + (b-a).to_s; a=b;
    b = Time.now; puts "12. " + (b-a).to_s; a=b;
    @title = 'Сайт "' + @project.name + '"'
    b = Time.now; puts "13. " + (b-a).to_s; a=b;

    puts "Totoal time: #{b - start}"
    puts "?????????????????????????????????????????????????????????????????????????????????"
  end
   
#  def design_to_xml
#    @project = AzProject.find(params[:id])
#    xml_inlude = { :include => { :az_pages => az_pages_options },  :except => ['updated_at', 'created_at'] }
#    render_to_string :xml => @project.to_xml(xml_inlude)
#  end
#
#  # GET /projects/1
#  # GET /projects/1.xml
#  def show_time
#    @project = AzProject.find(params[:id])
#    xml_inlude = { :include => { :az_pages => az_pages_options },  :except => ['updated_at', 'created_at'] }
#    render_to_string :xml => @project.to_xml(xml_inlude)
#  end
#
#  def get_scheme
#    dt = DocTools.new
#    file_name = dt.create_scheme_odg(design_to_xml)
#    send_file(file_name)
#    #render :xml => design_to_xml
#  end

  # GET /projects/new
  # GET /projects/new.xml
  def new
    @project = AzProject.new
    if params[:owner_id] != nil
      cmp = AzCompany.find(params[:owner_id])
      @project.owner_id = cmp.id
    else
      @project.owner_id = current_user.az_companies[0].id
    end

    @title = 'Создание нового сайта'

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /projects/1/edit
  def edit
    @project = AzProject.find(params[:id])
    @title = 'Свойства сайта "' + @project.name + '"'

    prepare_edit_data(@project)

    if !@project.can_user_update(current_user)
      redirect_to(project_forbidden_url)
      return
    end

    respond_to do |format|
      format.html { render :template => 'az_base_projects/edit'}
      #format.xml  { render :xml => @project.to_xml(xml_inlude) }
    end

  end

  # POST /projects
  # POST /projects.xml
  def create
    cmp = AzCompany.find(params[:az_project][:owner_id])
    @project = AzProject.create(params[:az_project][:name], cmp, current_user, params[:az_project][:public_access])

    @title = 'Создание нового сайта'

    respond_to do |format|
      if @project.id
        flash[:notice] = 'Проект успешно создан.'
        format.html { redirect_to(@project) }
      else
        format.html { render :template => 'az_projects/new', :owner_id => cmp.id }
      end
    end
  end

  # PUT /projects/1
  # PUT /projects/1.xml
  def update
    @project = AzProject.find(params[:id])

    prepare_show_data(@project.id)

    respond_to do |format|
      if !@project.can_user_update(current_user)
        format.html { redirect_to(project_forbidden_url) }
      elsif @project.update_attributes(params[:az_project]) # TODO project.update_attributes - не секьюрно!
        flash[:notice] = 'Проект успешно изменен.'
        format.html { redirect_to(@project) }
      else
        prepare_edit_data(@project)
        format.html { render :template => 'az_base_projects/edit'}
      end
    end
  end


  # DELETE /projects/1
  # DELETE /projects/1.xml
  def destroy
    @project = AzProject.find(params[:id])
    @project.deleting = true # По этому странному атрибуту страница определяет, что она не должна удалять свои задачи из Redmine
    @project.save

    if @project.can_user_delete(current_user)
      @project.destroy
    end

    respond_to do |format|
      format.html { redirect_to('/projects') }
      format.xml  { head :ok }
    end
  end


#  def add_worker
#    project = AzProject.find(params[:id])
#    user = AzUser.find_by_login(params[:user][:id])
#    project.add_worker(current_user, user)
#    respond_to do |format|
#      format.html { redirect_to(edit_az_project_url(project)) }
#    end
#
#  end

  # POST /remove_worker
  # POST /remove_worker.xml
#  def remove_worker
#    project = AzProject.find(params[:id])
#    user = AzUser.find_by_login(params[:user][:id])
#    project.remove_worker(current_user, user)
#    respond_to do |format|
#      format.html { redirect_to(edit_az_project_url(project)) }
#    end
#  end

  def change_members
    project = AzProject.find(params[:id])

    project_employee_ids = project.az_participants.collect{|p| p.az_employee.id}
    form_employee_ids = params[:employees].each_key.map{|k| k.to_i}

    form_employee_ids = form_employee_ids.uniq
    project_employee_ids = project_employee_ids.uniq

    employees_to_add = form_employee_ids - project_employee_ids
    employees_to_del = project_employee_ids - form_employee_ids

    project.az_participants.each do |p|
      p.destroy if employees_to_del.include?(p.az_employee.id)
    end

    employees_to_add.each do |e_id|
      employee = AzEmployee.find(:first, :conditions => {:id => e_id})
      AzParticipant.create(:az_project => project, :az_employee => employee, :owner => project.owner) if employee
    end

    respond_to do |format|
      format.html { render(:text => "Ok<script type='text/javascript'>window.setTimeout(function() { Windows.closeAll(); }, 800);</script>") }
    end
  end

#  def show_data_types
#    @project = AzProject.find(params[:id])
#    @project.get_data_types
#    respond_to do |format|
#      format.html { render "show_data_types" }
#    end
#  end

#  def tr_sort_public_pages
#    project = AzProject.find(params[:id])
#    project.tr_sort_public_pages
#    respond_to do |format|
#      format.html { render :text => 'Ok' }
#    end
#  end
#
#  def tr_sort_admin_pages
#    project = AzProject.find(params[:id])
#    project.tr_sort_admin_pages
#    respond_to do |format|
#      format.html { render :text => 'Ok' }
#    end
#  end

#  def show_pure_tr
#    prepare_tr_data
#    @title = 'Техническое задание на "' + @project.name + '"'
#    respond_to do |format|
#      format.html { render :template => 'az_base_projects/tr_edit/show', :layout => 'pure_tr', :locals => {:time => Time.now}}
#    end
#  end

  def copy
    project = AzProject.find(params[:id])
    company = AzCompany.find(params[:owner_id])

    ActiveRecord::Base.transaction do
      #project.make_copy(company)
    end

    f0 = File.open(Rails.root + "tmp/prj-#{project.id}", "w")
    a = Time.now
    project_hash = project.to_az_hash
    #puts " ...................................................................."
    b = Time.now; puts a-b; a=b;

    f0.write(project_hash.to_yaml)
    f0.close

    ActiveRecord::Base.transaction do
      AzProject.build_from_az_hash(project.to_az_hash, company)
    end

    respond_to do |format|
      format.html { redirect_to('/projects') }
    end
  end

  def add_component
    project = AzProject.find(params[:id])
    component = AzProjectBlock.find(params[:az_project_block_id])
    component_copy = component.make_copy(project.owner)
    project.components << component_copy
    respond_to do |format|
      format.html { render(:text => 'ok') }
    end
  end

  def remove_component
    project = AzProject.find(params[:id])
    component = AzProjectBlock.find(params[:az_project_block_id])
    if project.components.include?(component)
      component.destroy
    end
    
    respond_to do |format|
      format.html { redirect_to(:action => 'show', :show_type => 'components', :id => project.id) }
    end
  end

  def add_common
    project = AzProject.find(params[:id])
    common = AzCommon.find(params[:common_id])
    common.make_copy(project.owner, project)
    respond_to do |format|
      format.html { redirect_to(:action => 'edit', :id => project.id ) }
    end
  end

  def remove_common
    project = AzProject.find(params[:id])
    common = AzCommon.find(params[:common_id])
    common.destroy
    respond_to do |format|
      format.html { redirect_to(:action => 'edit', :id => project.id ) }
    end
  end

  def move_up
    move_higher(AzProject.find(params[:id]))
  end

  def move_down
    move_lower(AzProject.find(params[:id]))
  end

#  def change_definitions
#    project = AzProject.find(params[:id])
#    definition_ids = []
#
#    #params.select{|param| param[0].index('definition_') == 0 }
#
#    params.each do |param|
#      puts param[0].inspect
#      if param[0].index('definition_') == 0
#        definition_ids << Integer(param[1])
#      end
#    end
#
#    project.change_definitions(definition_ids)
#
#    respond_to do |format|
#      format.html { redirect_to(project) }
#    end
#
#  end

#  def expand_panel
#    project = AzProject.find(params[:id])
#    if session[:collapsed_project_panel] == nil
#      session[:collapsed_project_panel] = {}
#    end
#
#    session[:collapsed_project_panel][project.id] = false
#
#    respond_to do |format|
#      format.html { render :text => 'Ok' }
#    end
#  end
#
#  def collapse_panel
#    project = AzProject.find(params[:id])
#    if session[:collapsed_project_panel] == nil
#      session[:collapsed_project_panel] = {}
#    end
#
#    session[:collapsed_project_panel][project.id] = true
#
#    respond_to do |format|
#      format.html { render :text => 'Ok' }
#    end
#  end
  
  def show_participants_dialog
    project = AzProject.find(params[:id])
    #roles = AzRmRole.roles
    #employees = project.owner.get_employees.sort{|a, b| a.az_user.login <=> b.az_user.login}
    employees = project.owner.enabled_employees.sort{|a, b| a.az_user.login <=> b.az_user.login}
    respond_to do |format|
      format.html { render :partial => '/az_projects/dialogs/participants', :locals=> {:project => project, :employees => employees}}
    end

  end

#  def tr_collapse_public_pages
#     tr_collapse_expand_pages(AzPage::Page_user, :collapse)
#  end
#
#  def tr_expand_public_pages
#     tr_collapse_expand_pages(AzPage::Page_user, :expand)
#  end
#
#  def tr_collapse_admin_pages
#     tr_collapse_expand_pages(AzPage::Page_admin, :collapse)
#  end
#
#  def tr_expand_admin_pages
#    tr_collapse_expand_pages(AzPage::Page_admin, :expand)
#  end

  def test_pages_list
    @project = AzProject.find(params[:id])
    project_hash = @project.to_az_hash
    pp project_hash
    AzProject.build_from_az_hash(project_hash)
    respond_to do |format|
      format.html { render :text => "OK"}
    end
  end

  def activity
    project_id = params[:id]
    project = AzProject.find(project_id)
    activities = AzActivity.paginate(:all, :conditions => {:project_id => project_id}, :order => 'id desc', :page => params[:page], :per_page => 50)
    puts @az_activities.inspect
    respond_to do |format|
      format.html { render :template => 'az_projects/activity', :locals => {:project => project, :activities => activities}}
      #format.xml  { render :xml => @az_activities }
    end
  end

  def component_list
    project_id = params[:id]
    @project = AzProject.find(project_id)
    @block_list = @project.components
    respond_to do |format|
      format.html { render :partial => '/az_base_projects/project_right_box' }
    end
  end

  def status_edit_dialog
    project = AzProject.find(params[:id])
    statuses = AzProjectStatus.get_my_statuses.collect{ |s| [s.name, s.id]}
    respond_to do |format|
      format.html { render(:partial => '/az_projects/dialogs/status_edit_dialog', :locals => {:project => project, :statuses => statuses})}
    end
  end

  def update_status
    project = AzProject.find(params[:id])
    new_project_status = AzProjectStatus.find(params[:az_project][:az_project_status_id])

    ret = project.update_status(new_project_status)
    
    respond_to do |format|
      if ret
        format.html { render(:text => 'Ok')}
      else
        #puts '----------------------------------'
        #p project.errors
        #p project.errors[:base]
        #project.errors.each_pair do |k, v|
        #  p k
        #  p v
        #end
        format.html { render(:text => project.errors[:base], :status => :not_acceptable)}
      end
      
    end
  end

  def real_fork
    @project = AzProject.find(params[:id])
    @company = AzCompany.find(params[:owner_id])

    project_hash = {}
    ActiveRecord::Base.transaction do
      project_hash = @project.to_az_hash
    end

    ActiveRecord::Base.transaction do
      @project = AzProject.build_from_az_hash(project_hash, @company)
    end

    respond_to do |format|
      format.html { redirect_to(@project) }
    end
  end

  def fork
   
    @project = AzProject.find(params[:id])
    #project = AzProject.find(params[:id])
    company = AzCompany.find(params[:owner_id])

    #ActiveRecord::Base.transaction do
      #project.make_copy(company)
    #end

    #f0 = File.open(Rails.root + "tmp/prj-#{project.id}", "w")
    #a = Time.now
    #project_hash = project.to_az_hash
    #puts " ...................................................................."
    #b = Time.now; puts a-b; a=b;

    #f0.write(project_hash.to_yaml)
    #f0.close

    #ActiveRecord::Base.transaction do
    #  AzProject.build_from_az_hash(project.to_az_hash, company)
    #end

    #respond_to do |format|
    #  format.html { redirect_to('/projects') }
    #end
    #respond_to do |format|
    #  format.html { redirect_to('/projects') }
    #end
  end

  private

#  def tr_collapse_expand_pages(page_type, page_action)
#    project = AzProject.find(params[:id])
#
#    session[:tr_pages_collapsed] = {} if session[:tr_pages_collapsed] == nil
#
#    session[:tr_pages_collapsed][page_type] = (page_action == :collapse)
#    respond_to do |format|
#      format.html { render :text => 'Ok' }
#    end
#  end

  def commons_by_classes(project)
    project_commons_by_classes = {}
    Common_classes.each do |cc|
      project_commons_by_classes[cc] = cc[0].get_by_project(project)
    end
    return project_commons_by_classes
  end

  def prepare_edit_data(project)
    @company = AzCompany.find(project.owner_id)

    @definitions = AzDefinition.get_by_company(@company)

    @me = AzContact.new
    @me.az_user = current_user

    @project_statuses = AzProjectStatus.get_my_statuses.collect{ |s| [s.name, s.id]}

    @commons = {}
    Common_classes.each do |cc|
      @commons[cc] = cc[0].get_by_company(@company)
    end

    @project_commons = commons_by_classes(project)
  end

end
