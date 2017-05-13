class AzEnumDataTypesController < ApplicationController

  filter_access_to :index_user, :new, :create
  filter_access_to :all, :attribute_check => true

  layout "main"
  
  # GET /az_struct_data_types
  # GET /az_struct_data_types.xml
  def index
    @structs = AzStructDataType.all

    @seed_structs = AzStructDataType.find_all_by_seed(true)

    @pages_structs = @structs.select { |s| s.typed_pages.size > 0 }
    @unussigned_structs = @structs - @pages_structs

    @structs_assigned = @pages_structs.select { |s| s.typed_pages.size > 0 }#&& s.typed_pages.detect { |pg| pg.get_project_over_block.instance_of?(AzProject) } }

    @structs_assigned_to_project = @structs_assigned.select { |s| s.typed_pages.detect { |pg| pg.get_project_over_block.instance_of?(AzProject) } }
    @structs_assigned_to_block = @structs_assigned.select { |s| s.typed_pages.detect { |pg| !pg.get_project_over_block.instance_of?(AzProject) } }

    @title = 'Структуры'

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @az_struct_data_types }
    end
  end


  def index_user

    #@my_companies = current_user.my_works
    #@structs = AzStructDataType.get_by_companies(@my_companies)

    @title = 'Структуры'

    respond_to do |format|
      format.html {render :text => 'ok'}
      #format.xml  { render :xml => @structs }
    end
  end


  # GET /az_struct_data_types/1
  # GET /az_struct_data_types/1.xml
  def show
    @az_struct_data_type = AzStructDataType.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @az_struct_data_type }
    end
  end

  # GET /az_struct_data_types/new
  # GET /az_struct_data_types/new.xml
  def new
    @az_struct_data_type = AzStructDataType.new
    @az_struct_data_type.owner_id = params[:owner_id]
    @az_struct_data_type.az_base_project_id = params[:az_base_project_id]

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @az_struct_data_type }
    end
  end

  # GET /az_struct_data_types/1/edit
  def edit
    @az_struct_data_type = AzStructDataType.find(params[:id])
    @title = 'Структура "' + @az_struct_data_type.name + '"'
  end

  # POST /az_struct_data_types
  # POST /az_struct_data_types.xml
  def create
    @az_struct_data_type = AzStructDataType.new(params[:az_struct_data_type])

    respond_to do |format|
      if @az_struct_data_type.save
        flash[:notice] = 'Структура данных успешно создана.'
        format.html { redirect_to(:action => 'edit', :id => @az_struct_data_type.id) }
        format.xml  { render :xml => @az_struct_data_type, :status => :created, :location => @az_struct_data_type }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @az_struct_data_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /az_struct_data_types/1
  # PUT /az_struct_data_types/1.xml
  def update
    @az_struct_data_type = AzStructDataType.find(params[:id])

    respond_to do |format|
      if @az_struct_data_type.update_attributes(params[:az_struct_data_type])
        flash[:notice] = 'Структура данных успешно изменена.'
        format.html { redirect_to(@az_struct_data_type) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @az_struct_data_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /az_struct_data_types/1
  # DELETE /az_struct_data_types/1.xml
  def destroy
    @az_struct_data_type = AzStructDataType.find(params[:id])
    project = @az_struct_data_type.az_base_project
    @az_struct_data_type.destroy

    respond_to do |format|
      if project != nil
        format.html { redirect_to(project) }
      else
        format.html { redirect_to(:action => 'index_user') }
      end
      format.xml  { head :ok }
    end
  end

  def copy
    @az_struct_data_type = AzStructDataType.find(params[:id])
    @az_struct_data_type.make_copy(current_user.az_companies[0], nil)

    respond_to do |format|
      format.html { redirect_to(az_struct_data_types_url) }
      format.xml  { head :ok }
    end

  end

  def info_tooltip
    @struct_data_type = AzStructDataType.find(params[:id])
    respond_to do |format|
      format.html { render :partial => "az_struct_data_types/tooltips/show_struct_info", :locals => {:az_struct_data_type => @struct_data_type} }
    end
  end

end
