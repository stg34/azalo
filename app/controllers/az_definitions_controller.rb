class AzDefinitionsController < ApplicationController

  layout "main"

  filter_access_to :index_user, :new, :create, :tr_new_definition_dialog, :create_definition
  filter_access_to :all, :attribute_check => true

  # GET /az_definitions
  # GET /az_definitions.xml
  def index
    @az_definitions = AzDefinition.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @az_definitions }
    end
  end
  
  # GET /az_definitions
  # GET /az_definitions.xml
  def index_user

    @my_companies = current_user.my_works
    @definitions = AzDefinition.get_by_companies(@my_companies)

    @title = 'Термины и определения'

    respond_to do |format|
      format.html # index.html.erb
      #format.xml  { render :xml => @az_definitions }
    end
  end

  # GET /az_definitions/1
  # GET /az_definitions/1.xml
  def show
    @az_definition = AzDefinition.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @az_definition }
    end
  end

  # GET /az_definitions/new
  # GET /az_definitions/new.xml
  def new
    @az_definition = AzDefinition.new
    @az_definition.owner_id = params[:owner_id]
    @az_definition.az_base_project_id = params[:az_base_project_id]
    @statuses = @az_definition.statuses_for_select

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @az_definition }
    end
  end

  # GET /az_definitions/1/edit
  def edit
    @az_definition = AzDefinition.find(params[:id])
    @statuses = @az_definition.statuses_for_select
  end

  # POST /az_definitions
  # POST /az_definitions.xml
  def create
    @az_definition = AzDefinition.new(params[:az_definition])

    respond_to do |format|
      if @az_definition.save
        flash[:notice] = 'Определение успешно создано.'
        format.html { redirect_to(@az_definition) }
        format.xml  { render :xml => @az_definition, :status => :created, :location => @az_definition }
      else
        @statuses = @az_definition.statuses_for_select
        format.html { render :action => "new" }
        format.xml  { render :xml => @az_definition.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /az_definitions/1
  # PUT /az_definitions/1.xml
  def update
    @az_definition = AzDefinition.find(params[:id])

    respond_to do |format|
      if @az_definition.update_attributes(params[:az_definition])
        flash[:notice] = 'Определение успешно обновлено.'
        format.html { redirect_to(@az_definition) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @az_definition.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /az_definitions/1
  # DELETE /az_definitions/1.xml
  def destroy
    @az_definition = AzDefinition.find(params[:id])
    @az_definition.destroy

    respond_to do |format|
      format.html { redirect_to(:action => 'index_user') }
      format.xml  { head :ok }
    end
  end

  def move_up
    definition = AzDefinition.find(params[:id])
    definition.move_up
    respond_to do |format|
      format.html { redirect_to(:back) }
    end
  end

  def move_down
    definition = AzDefinition.find(params[:id])
    definition.move_down
    respond_to do |format|
      format.html { redirect_to(:back) }
    end
  end  

  def tr_new_definition_dialog
    definition = AzDefinition.new
    definition.az_base_project_id = params[:az_base_project_id]
    #definition.owner_id = params[:owner_id]
    #url = create_definition_path(:owner_id => params[:owner_id])
    url = {:controller => :az_definitions, :action => :create_definition, :owner_id => params[:owner_id]}
    #puts '------------------------------------'
    #url = ''
    locals = { :definition => definition, :url => url}
    respond_to do |format|
      format.html { render :partial => '/az_base_projects/tr_edit/tr_edit_definition_dialog_container', :locals => locals }
    end
  end

  def create_definition
    definition = AzDefinition.new
    definition.definition = params['az_definition']['definition']
    definition.name = params['az_definition']['name']
    definition.owner_id = params['owner_id']
    definition.az_base_project_id = params['az_definition']['az_base_project_id']

    ret = definition.save
    controller = definition.az_base_project.class.to_s.underscore.pluralize
    respond_to do |format|
      if ret
        format.html { render :text => "<script type='text/javascript'>Windows.closeAll(); update_definitions_in_tr();</script>" }
      else
        url = {:controller => :az_definitions, :action => :create_definition, :owner_id => params[:owner_id]}
        locals = { :definition => definition, :url => url}
        format.html { render :partial => '/az_base_projects/tr_edit/tr_edit_definition_dialog', :locals => locals }
      end
    end
  end

  def description_text_dialog
    definition = AzDefinition.find(params[:id])
    #update_url = {:controller => 'az_definitions', :action => "update_description", :id => definition.id}
    url = {:controller => 'az_definitions', :action => "update_description", :id => definition.id}
    locals = { :definition => definition, :url => url}
    respond_to do |format|
      format.html { render :partial => '/az_base_projects/tr_edit/tr_edit_definition_dialog_container', :locals => locals }
    end
  end

  def status_dialog
    definition = AzDefinition.find(params[:id])
    update_url = {:controller => "az_definitions", :action => "update_status", :id => definition.id}
    statuses = definition.statuses_for_select
    locals = { :entity => definition, :update_url => update_url, :statuses => statuses}

    respond_to do |format|
      format.html { render :partial => '/az_base_projects/tr_edit/tr_edit_status_dialog_container', :locals => locals }
    end
  end

  def update_description
    definition = AzDefinition.find(params[:id])
    definition.definition = params['az_definition']['definition']
    if params['az_definition']['name']
      definition.name = params['az_definition']['name']
    end
    ret = definition.save
    controller = definition.az_base_project.class.to_s.underscore.pluralize
    respond_to do |format|
      if ret
        format.html { render :text => "<script type='text/javascript'>Windows.closeAll(); update_definitions_in_tr();</script>" }
      else
        url = {:controller => 'az_definitions', :action => "update_description", :id => definition.id}
        locals = { :definition => definition, :url => url}
        format.html { render :partial => '/az_base_projects/tr_edit/tr_edit_definition_dialog', :locals => locals }
      end
    end
  end

  def update_status
    definition = AzDefinition.find(params[:id])
    definition.status = params["az_definition"]["status"]
    ret = definition.save
    controller = definition.az_base_project.class.to_s.underscore.pluralize
    respond_to do |format|
      if ret
        format.html { render :text => "<script type='text/javascript'>Windows.closeAll(); update_definitions_in_tr();</script>" }
      else
        update_url = {:controller => 'az_definitions', :action => "update_description", :id => definition.id}
        statuses = definition.statuses_for_select
        locals = { :entity => definition, :update_url => update_url, :statuses => statuses}
        format.html { render :partial => '/az_base_projects/tr_edit/tr_edit_status_dialog_container', :locals => locals }
      end
    end
  end

end
