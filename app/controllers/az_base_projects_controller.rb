class AzBaseProjectsController < ApplicationController

  filter_access_to :index_user, :new, :create, :guest_show, :index
  filter_access_to :all, :attribute_check => true

  layout "main"

  def add_definition

    @commons_class = get_class(params)

    prj_class = get_class(params)

    project = prj_class.find(params[:id])
    definition = AzDefinition.find(params[:definition_id])
    project.add_definition(definition)

    respond_to do |format|
      format.html { redirect_to(:action => 'edit', :id => project.id ) }
    end
  end

  def remove_definition
    prj_class = get_class(params)
    project = prj_class.find(params[:id])
    definition = AzDefinition.find(params[:definition_id])
    project.remove_definition(definition)

    respond_to do |format|
      format.html { redirect_to(:action => 'edit', :id => project.id ) }
    end
  end

  def add_definition_a
    prj_class = get_class(params)
    project = prj_class.find(params[:id])
    definition = AzDefinition.find(params[:definition_id])
    project.add_definition(definition)

    respond_to do |format|
      format.html { render(:text => 'ok') }
    end
  end

  def access_edit_dialog
    project = AzProject.find(params[:id])
    #statuses = [["Публичный", 1], ["Приватный", 0]]
    respond_to do |format|
      format.html { render(:partial => '/az_projects/dialogs/access_edit_dialog', :locals => {:project => project})}
    end
  end

  def change_public_access
    project = AzBaseProject.find(params[:id])
    project.public_access = params[:az_project][:public_access]
    respond_to do |format|
      if project.save
        format.html { render(:text => 'Ok')}
      else
        project.errors.each {|e| puts e.inspect}
        format.html { render(:text => 'Отклонено.', :status => :not_acceptable)}
      end

    end
  end

  def remove_definition_a
    prj_class = get_class(params)
    project = prj_class.find(params[:id])
    definition = AzDefinition.find(params[:definition_id])
    project.remove_definition(definition)
    
    respond_to do |format|
      format.html { render(:text => 'ok') }
    end
  end

  def move_definition_up_tr
    project = AzBaseProject.find(params[:id])
    dfn_id = params[:definition_id]
    project.move_definition_up_tr(dfn_id)
    respond_to do |format|
      format.html { render(:text => 'ok') }
    end
  end

  def move_definition_down_tr
    project = AzBaseProject.find(params[:id])
    dfn_id = params[:definition_id]
    project.move_definition_down_tr(dfn_id)
    respond_to do |format|
      format.html { render(:text => 'ok') }
    end
  end

  def tr_definitions_content
    project = AzBaseProject.find(params[:id])
    definitions = project.get_all_definitions

    respond_to do |format|
      format.html { render :partial => '/az_base_projects/tr_edit/tr_block_definitions', :locals => {:project => project, 
                                                                                                     :definitions => definitions,
                                                                                                     :permitted_to_edit => permitted_to?(:edit, project),
                                                                                                     :permitted_to_show => permitted_to?(:show, project)} }
    end
  end

  def move_common_up_tr
    project = AzBaseProject.find(params[:id])
    cmn_id = params[:common_id]
    project.move_common_up_tr(cmn_id)
    respond_to do |format|
      format.html { render(:text => 'ok') }
    end
  end

  def move_common_down_tr
    project = AzBaseProject.find(params[:id])
    cmn_id = params[:common_id]
    project.move_common_down_tr(cmn_id)
    respond_to do |format|
      format.html { render(:text => 'ok') }
    end
  end

  def tr_structs_validators_content
    @project = AzBaseProject.find(params[:id])
    #blocks = @project.get_project_block_list
    @data_types = prepare_data_types(@project)
    @validators = get_validators_from_data_types(@data_types)
    respond_to do |format|
      if @layout_tr == nil
        format.html { render :partial => '/az_base_projects/tr_edit/data_types' , :locals => {:project => @project,
                                                                                              :data_types => @data_types,
                                                                                              :validators => @validators,
                                                                                              :permitted_to_edit => permitted_to?(:edit, @project),
                                                                                              :permitted_to_show => permitted_to?(:show, @project)} }
      end
    end
  end

#  def tr_public_pages_content
#
#    project = get_class(params).find(params[:id])
#    project_tree = PrTree.build(project)
#    public_pages = []
#    public_page_ids = {}
#
#    project_tree.walk(nil, AzPage::Page_user) do |node|
#      if !node.main_page.root && !public_page_ids[node.main_page.id]
#        public_pages << node.main_page
#        public_page_ids[node.main_page.id] = node.main_page.id
#      end
#    end
#
#
#    respond_to do |format|
#      format.html { render :partial => '/az_base_projects/tr_edit/pages', :locals => {:project => project, :page_list => public_pages,
#                                                                                             :permitted_to_edit => permitted_to?(:edit, project)} }
#    end
#  end
#
#  def tr_admin_pages_content
#
#
##    @project_tree = PrTree.build(@project)
##
##      @all_pages = []
##
##      @public_pages = []
##      @admin_pages = []
##      public_page_ids = {}
##      admin_page_ids = {}
##
##      @project_tree.walk(nil, AzPage::Page_user) do |node|
##        if !node.main_page.root && !public_page_ids[node.main_page.id]
##          @public_pages << node.main_page
##          public_page_ids[node.main_page.id] = node.main_page.id
##        end
##      end
##
##      @project_tree.walk(nil, AzPage::Page_admin) do |node|
##        if !node.main_page.root && !admin_page_ids[node.main_page.id]
##          @admin_pages << node.main_page
##          admin_page_ids[node.main_page.id] = node.main_page.id
##        end
##      end
#
#
#    @project = get_class(params).find(params[:id])
#    respond_to do |format|
#      format.html { render :partial => '/az_base_projects/tr_edit/admin_pages', :locals => {:project => @project,
#                                                                                            :permitted_to_edit => permitted_to?(:edit, @project)} }
#    end
#  end

#  def show_design
#    @project = get_class(params).find(params[:id])
#    show_type = get_show_type_name(@project.class)
#    session[show_type] = :design
#    redirect_to(@project)
#  end
#
#  def show_data
#    @project = get_class(params).find(params[:id])
#    show_type = get_show_type_name(@project.class)
#    session[show_type] = :data
#    redirect_to(@project)
#  end
#
#  def show_blocks
#    @project = get_class(params).find(params[:id])
#    show_type = get_show_type_name(@project.class)
#    session[show_type] = :blocks
#    redirect_to(@project)
#  end
#
#  def show_description
#    @project = get_class(params).find(params[:id])
#    show_type = get_show_type_name(@project.class)
#    session[show_type] = :description
#    redirect_to(@project)
#  end

  def show_sub_tree
    
    @project = AzBaseProject.find(params[:id])

    page_id = params[:page_id]
    parent_page_id = params[:parent_page_id]
    show_type = params[:show_type]
    @show_type = show_type.to_sym

    link = AzPageAzPage.find(:first, :conditions => {:page_id => page_id, :parent_page_id => parent_page_id})

    if link
      @project_tree = PrTree.build_sub_tree(@project, link)
    end

    # TODO копипаста. см ниже
    pages = []
    @project_tree.walk do |node|
      pages<< node.main_page
    end

    if @project_tree.root.main_page.embedded && !link.az_parent_page.root
      nodes = @project_tree.root.get_children
    else
      nodes = [@project_tree.root]
    end


    respond_to do |format|
      if link
        format.html { render :partial => 'az_base_projects/show_sub_node_rows', :locals => {:nodes => nodes }}
      else
        format.html { render :text => 'Error', :status => :not_acceptable}
      end
    end
  end

  def show_sub_tree2
    @project = AzBaseProject.find(params[:id])
    page_id = params[:page_id]
    show_type = params[:show_type]
    @show_type = show_type.to_sym
    page = AzPage.find(page_id)

    link = page.parent_links[0]
    @project_tree = PrTree.build_sub_tree(nil, link)

    # TODO копипаста. см выше
    pages = []
    @project_tree.walk do |node|
      pages<< node.main_page
    end

    respond_to do |format|
      if link
        format.html { render :partial => 'az_base_projects/show_sub_node_rows', :locals => {:nodes => @project_tree.root.get_children }}
      else
        format.html { render :text => 'Error', :status => :not_acceptable}
      end
    end
  end

  def datatype_list
    project_id = params[:id]
    @project = AzBaseProject.find(project_id)
    @all_data_types = @project.get_all_data_types
    @data_type_list_with_collections = AzPageType.page_types_with_collections(@all_data_types)

    respond_to do |format|
      format.html { render :partial => '/az_base_projects/data_right_box' }
    end
  end

  def edit_tr
    @project = AzBaseProject.find(params[:id])

    if !(@project.cache && fragment_exist?(:action => 'edit_tr', :id => params[:id]))
      prepare_tr_data
    end
    
    @title = 'Техническое задание на "' + @project.name + '"'
    respond_to do |format|
      if @layout_tr == nil
        format.html { render :template => 'az_base_projects/tr_edit/edit1' }
      end
    end
  end

  def show_pure_tr

    @project = AzBaseProject.find(params[:id])
    prepare_tr_data
    @title = 'Техническое задание на "' + @project.name + '"'
    
    respond_to do |format|
      format.html { render(:template => 'az_base_projects/tr_edit/show', :layout => 'pure_tr', :locals => {:time => Time.now} ) }
    end
  end

  def show_pure_tr_md

    @project = AzBaseProject.find(params[:id])
    prepare_tr_data
    @title = 'Техническое задание на "' + @project.name + '"'

    respond_to do |format|
      format.html { render(:template => 'az_base_projects/tr_edit/show_md', :layout => 'md', :content_type => 'text/plain', :locals => {:time => Time.now} ) }
    end
  end

  def tr_doc
    @project = AzBaseProject.find(params[:id])
    prepare_tr_data
    @title = 'Техническое задание на "' + @project.name + '"'
    t = Time.now
    str = render_to_string(:template => 'az_base_projects/tr_edit/show', :layout => 'pure_tr', :locals => {:time => Time.now} )

    temp_tr = Tempfile.new(['tr', '.html'])
    name = temp_tr.path
    temp_tr.puts str
    temp_tr.close

    temp_tr_doc = Tempfile.new(['tr', '.doc'])
    name_doc = temp_tr_doc.path
    temp_tr_doc.close

    cmd = "echo `date` >> /tmp/abi.log; abiword --verbose=2 -t doc #{name} -o #{name_doc} -u boris >> /tmp/abi.log 2>&1; echo OK >> /tmp/abi.log"
    puts "---------------------------------------------------------------------------------------------------------------------"
    puts cmd
    puts "---------------------------------------------------------------------------------------------------------------------"
    ret = system(cmd)

#    IO.popen("abiword --plugin AbiCommand 2>&1", 'w') do |f|
#      f.puts("server /tmp/abiword_errors \n")
#      f.puts("new")
#      f.puts("inserttext 'hello'")
#      f.puts("save /tmp/toronto3.doc \n")
#    end
    file_name_to_send = "ТЗ " + @project.name.gsub(/[\n\r\t]/, '_') + " " + t.strftime('%Y.%m.%d %H.%M.%S') + ".doc"
    if ret
      send_file(name_doc, :filename => file_name_to_send)
    else
      render :text => "Error"
    end

    #respond_to do |format|
      #format.html {render :file => "/tmp/tr.doc"}
    #end
  end

  def show_tr
    edit_tr
  end

  def add_common_a
    project = AzBaseProject.find(params[:id])
    common = AzCommon.find(params[:common_id])
    #common_class_name = common["type"].to_s.underscore.pluralize
    common.make_copy_common(project.owner, project)

    #project1 = AzProject.find(params[:id])
    #commons = eval("project1.#{common_class_name}")

    respond_to do |format|
      format.html { render(:text => 'ok') }
    end
  end

  def remove_common_a
    common = AzCommon.find(params[:common_id])
    common.destroy

    respond_to do |format|
      format.html { render(:text => 'ok') }
    end
  end

  def prepare_tr_data
    @project_tree = PrTree.build(@project)
   
    @all_pages = []

    @public_pages = []
    @admin_pages = []

    @project_tree.walk_public_subtree do |node|
      @public_pages << node.main_page
    end

    @project_tree.walk_admin_subtree do |node|
      @admin_pages << node.main_page
    end

    @definitions = @project.get_all_definitions

    @data_types = prepare_data_types(@project)
    @validators = get_validators_from_data_types(@data_types)
  end

  def prepare_data_types(project)
    # TODO это нужно вынести в модель и написать тестов
    
    blocks = project.components

    data_types = AzBaseDataType.find_all_by_az_base_project_id(project.id)

    blocks.each do |block|
      data_types.concat(AzBaseDataType.find_all_by_az_base_project_id(block.id))
    end

    data_types = data_types.select{|dt| dt.instance_of?(AzStructDataType)}

    data_types.sort!{|a, b| b.tr_position = 999999999 if b.tr_position == nil; a.tr_position = 999999999 if a.tr_position == nil; a.tr_position <=> b.tr_position}
    return data_types
  end

  def tr_commons_content
    project = AzBaseProject.find(params[:id])
    common_class = params[:common_class]
    get_tr_commons_content_internal(project, common_class)
  end

  private

  def get_show_type_name(prj_class)
    if prj_class == AzProject
      return :project_show_type
    end
    return :project_block_show_type
  end

  def get_class(params)
    controller_name = params[:controller]
    class_name = controller_name.singularize.classify
    return eval(class_name)
  end

  def get_validators_from_data_types(data_types)
    validators = []
    data_type_ids = []
    @data_types.each do |t|
      if t.instance_of?(AzStructDataType)
        data_type_ids << t.id
      end
    end
    vars = AzVariable.find(:all, :conditions => {:az_struct_data_type_id => data_type_ids})
    var_ids = vars.collect{|v| v.id}
    validators = AzValidator.find(:all, :conditions => {:az_variable_id => var_ids}, :group => "name, description, message")
    return validators
    #--------------------------------------------------------------------------
#    validators = {}
#    @data_types.each do |t|
#      if t.instance_of?(AzStructDataType)
#        t.az_variables.each do |az_variable|
#
#          i = 0
#          az_variable.az_validators.each do |v|
#            i += 1
#            key = v.name + v.description + v.message
#            validators[key] = v
#          end
#        end
#      end
#   end
#   return validators.each_value
  end

  def move_higher(project)
    project.move_up
    respond_to do |format|
      format.html { redirect_to(:back) }
    end
  end

  def move_lower(project)
    project.move_down
    respond_to do |format|
      format.html { redirect_to(:back) }
    end
  end

  def get_tr_commons_content_internal(project, common_class_name)
    #commons = eval("project.#{common_class_name}")
    commons = project.get_all_commons(common_class_name)
    respond_to do |format|
      format.html { render :partial => '/az_base_projects/tr_edit/tr_block_common', :locals => {:project => project,
                                                                                                :commons => commons,
                                                                                                :common_class_name => common_class_name,
                                                                                                :permitted_to_edit => permitted_to?(:edit, project),
                                                                                                :permitted_to_show => permitted_to?(:show, project)} }
    end
  end

end
