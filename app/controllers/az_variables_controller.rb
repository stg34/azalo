class AzVariablesController < ApplicationController

  filter_access_to :all

  layout "main"

  # GET /az_variables
  # GET /az_variables.xml
  def index
    @az_variables = AzVariable.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @az_variables }
    end
  end

  # GET /az_variables/1
  # GET /az_variables/1.xml
  def show
    @az_variable = AzVariable.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @az_variable }
    end
  end

  # GET /az_variables/new
  # GET /az_variables/new.xml
  def new
    @az_variable = AzVariable.new
    struct = AzStructDataType.find(params[:az_struct_data_type_id])
    @az_variable.az_struct_data_type = struct

    prepare_new_create_common_data(struct)

    @title = 'Новая переменная'

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @az_variable }
    end
  end

  # GET /az_variables/1/edit
  def edit
    @az_variable = AzVariable.find(params[:id])
    @data_types = AzSimpleDataType.get_my_types
    @validtors = AzValidator.get_by_company(@az_variable.owner)
    @project_structs_with_collections = []

    if @az_variable.az_struct_data_type != nil
      if @az_variable.az_struct_data_type.az_base_project != nil
        prj = @az_variable.az_struct_data_type.az_base_project
        @all_data_types = AzBaseDataType.find_all_by_az_base_project_id(prj.id)
      else
        @all_data_types = AzBaseDataType.get_unussigned(@az_variable.owner)
      end
      @project_structs_with_collections = AzPageType.page_types_with_collections(@all_data_types)
    end

    @title = 'Переменная "' + @az_variable.name + '"'

  end

  # POST /az_variables
  # POST /az_variables.xml
  def create
    # TODO логика должна быть перенесена в модель
    @az_variable = AzVariable.new(params[:az_variable])
    struct = AzStructDataType.find(@az_variable.az_struct_data_type_id)
    @az_variable.owner_id = struct.owner_id

    res = @az_variable.save

    v_ids = []

    if res
      if params[:validators] != nil
        params[:validators].each_key do |v_id|
          v_id = Integer(v_id)
          validator = AzValidator.find(v_id)
          if validator
            validator.make_copy_validator(@az_variable.owner, @az_variable)
          end
        end
      end
      #puts '========================================================================'
    else
      if params[:validators] != nil
        params[:validators].each_key do |v_id|
          v_ids << Integer(v_id)
        end
      end
      
    end

    respond_to do |format|
      if res
        #flash[:notice] = 'Переменная успешно создана.'
        format.html { render :text => "<script type='text/javascript'>Windows.closeAll(); update_variables_list_in_structure(#{struct.id});</script>" }
        #format.html { redirect_to(edit_az_variable_path(@az_variable)) }
        #format.xml  { render :xml => @az_variable, :status => :created, :location => @az_variable }
      else
        prepare_new_create_common_data(struct)
        #format.html { render :action => "new" }
        format.html { render :partial => '/az_variables/dialogs/new_dialog_container', :locals => {:checked_validators => v_ids}}
        #format.xml  { render :xml => @az_variable.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /az_variables/1
  # PUT /az_variables/1.xml
  def update
    @az_variable = AzVariable.find(params[:id])
    struct = @az_variable.az_struct_data_type
    @data_types = AzSimpleDataType.get_my_types
    @validtors = AzValidator.get_by_company(@az_variable.owner)
    @project_structs_with_collections = []


    # TODO дублирование кода с edit
    if @az_variable.az_struct_data_type != nil
      if @az_variable.az_struct_data_type.az_base_project != nil
        prj = @az_variable.az_struct_data_type.az_base_project
        @all_data_types = AzBaseDataType.find_all_by_az_base_project_id(prj.id)
      else
        @all_data_types = AzBaseDataType.get_unussigned(@az_variable.owner)
      end
      @project_structs_with_collections = AzPageType.page_types_with_collections(@all_data_types)
    end

    respond_to do |format|
      # TODO
      if @az_variable.update_attributes(params[:az_variable])
        #flash[:notice] = 'Переменная успешна изменена.'
        format.html { render :text => "<script type='text/javascript'>Windows.closeAll(); update_variables_list_in_structure(#{struct.id});</script>" }
        format.xml  { head :ok }
      else
        #format.html { render :action => "edit" }
        format.html { render :partial => '/az_variables/dialogs/edit_dialog_container'}
        format.xml  { render :xml => @az_variable.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /az_variables/1
  # DELETE /az_variables/1.xml
  def destroy
    @az_variable = AzVariable.find(params[:id])

    struct = @az_variable.az_struct_data_type

    @az_variable.destroy

    respond_to do |format|
      if struct == nil
        format.html { redirect_to(az_variables_url) }
      else
        format.html { render :text => "ok" }
      end
      format.xml  { head :ok }
    end
  end

  def add_validator
    variable = AzVariable.find(params[:id])
    validator = AzValidator.find(params[:validator_id])
    variable.add_validator(validator)
    @validtors = AzValidator.get_by_company(variable.owner)

    respond_to do |format|
      #format.html { redirect_to(:action => 'edit', :id => variable.id ) }
      format.html { render( :partial => '/az_variables/validators', :locals => {:variable => variable}) }
    end
  end

  def remove_validator
    variable = AzVariable.find(params[:id])
    validator = AzValidator.find(params[:validator_id])
    variable.remove_validator(validator)
    @validtors = AzValidator.get_by_company(variable.owner)

    respond_to do |format|
      #format.html { redirect_to(:action => 'edit', :id => variable.id ) }
      format.html { render( :partial => '/az_variables/validators', :locals => {:variable => variable}) }
    end
  end
  
  def show_new_variable_dialog
    #page = AzPage.find(params[:id])
    @az_variable = AzVariable.new
    
    struct = AzStructDataType.find(params[:id])
    @az_variable.az_struct_data_type = struct

    prepare_new_create_common_data(struct)

    respond_to do |format|
      format.html { render :partial => '/az_variables/dialogs/new_dialog_container', :locals => {:checked_validators => []}}
    end
  end

  def show_edit_variable_dialog
    #page = AzPage.find(params[:id])
    @az_variable = AzVariable.find(params[:id])

    struct = @az_variable.az_struct_data_type
    #@az_variable.az_struct_data_type = struct

    prepare_new_create_common_data(struct)

    respond_to do |format|
      format.html { render :partial => '/az_variables/dialogs/edit_dialog_container'}
    end
  end

  def move_up
    @variable = AzVariable.find(params[:id])
    @variable.move_higher
    respond_to do |format|
      #format.html {redirect_to(edit_az_struct_data_type_path(@variable.az_struct_data_type))}
      format.html { render :text => "ok" }
    end
  end

  def move_down
    @variable = AzVariable.find(params[:id])
    @variable.move_lower
    respond_to do |format|
      #format.html {redirect_to(edit_az_struct_data_type_path(@variable.az_struct_data_type))}
      format.html { render :text => "ok" }
    end
  end

  private
  def prepare_new_create_common_data(struct)

    @validtors = AzValidator.get_by_company(struct.owner)

    @project_structs_with_collections = []

    if struct.owner != nil
      prj = struct.az_base_project
      if prj
        @all_data_types = AzBaseDataType.find_all_by_az_base_project_id(prj.id)
      else
        @all_data_types = AzBaseDataType.find_all_by_owner_id(struct.owner_id, :conditions => 'az_base_project_id is null')
      end
      @project_structs_with_collections = AzPageType.page_types_with_collections(@all_data_types)
    end

    @data_types = AzSimpleDataType.get_my_types

  end


end
