class AzStructDataTypesController < ApplicationController

  filter_access_to :index_user, :new, :create, :index
  filter_access_to :all, :attribute_check => true

  layout "main"
  
  # GET /az_struct_data_types
  # GET /az_struct_data_types.xml
  def index
    #@structs = AzStructDataType.all
    @structs = AzStructDataType.paginate(:all, :conditions => {:copy_of => nil}, :order => 'created_at desc', :page => params[:page])

    #@seed_structs = AzStructDataType.find_all_by_seed(true)

    #@pages_structs = @structs.select { |s| s.typed_pages.size > 0 }
    #@unussigned_structs = @structs - @pages_structs

    #@structs_assigned = @pages_structs.select { |s| s.typed_pages.size > 0 }#&& s.typed_pages.detect { |pg| pg.get_project_over_block.instance_of?(AzProject) } }

    #@structs_assigned_to_project = @structs_assigned.select { |s| s.typed_pages.detect { |pg| pg.get_project_over_block.instance_of?(AzProject) } }
    #@structs_assigned_to_block = @structs_assigned.select { |s| s.typed_pages.detect { |pg| !pg.get_project_over_block.instance_of?(AzProject) } }

    @title = 'Структуры'

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @az_struct_data_types }
    end
  end


  def index_user

    @my_companies = current_user.my_works
    @structs = AzStructDataType.get_by_companies(@my_companies)

    @title = 'Структуры'

    respond_to do |format|
      format.html # index.html.erb
      #format.xml  { render :xml => @structs }
    end
  end


  # GET /az_struct_data_types/1
  # GET /az_struct_data_types/1.xml
  def show
    @struct = AzStructDataType.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      #format.xml  { render :xml => @struct }
    end
  end

  # GET /az_struct_data_types/new
  # GET /az_struct_data_types/new.xml
  def new
    @az_struct_data_type = AzStructDataType.new
    @az_struct_data_type.owner_id = params[:owner_id]
    @az_struct_data_type.az_base_project_id = params[:az_base_project_id]
    @statuses = @az_struct_data_type.statuses_for_select
    @title = 'Новая структура'

    @store_structs = AzStructDataType.get_by_companies([@az_struct_data_type.owner])

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @az_struct_data_type }
    end
  end

  # GET /az_struct_data_types/1/edit
  def edit

    puts "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
    #puts ActionController::Base.consider_all_requests_local
    puts "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
    #puts nil.action_view

    @statuses = @az_struct_data_type.statuses_for_select
    @az_struct_data_type = AzStructDataType.find(params[:id])
    @title = 'Структура "' + @az_struct_data_type.name + '"'



    @az_struct_data_type.az_variables.each_with_index do |variable, i|
      if variable.az_base_data_type == nil
        @az_struct_data_type.az_variables[i].az_base_data_type = AzSimpleDataType.get_undefined_data_type
        @az_struct_data_type.az_variables[i].save
      end
    end

    ############################################################################
    #@data_types = AzSimpleDataType.get_my_types
    #if @az_struct_data_type.az_base_project != nil
    #  prj = @az_struct_data_type.az_base_project
    #  @all_data_types = AzBaseDataType.find_all_by_az_base_project_id(prj.id)
    #else
    #  @all_data_types = AzBaseDataType.get_unussigned(@az_struct_data_type.owner)
    #end
    #@project_structs_with_collections = AzPageType.page_types_with_collections(@all_data_types)
    ############################################################################
    respond_to do |format|
      format.html # new.html.erb
    end

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
        @store_structs = AzStructDataType.get_by_companies([@az_struct_data_type.owner])
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

  def copy_and_attach_to_project
    @az_struct_data_type = AzStructDataType.find(params[:id])
    project = AzBaseProject.find(params[:project_id])
    struct = @az_struct_data_type.make_copy_data_type(project.owner, project)
    respond_to do |format|
      format.html { redirect_to(:action => 'edit', :id => struct.id) }
      format.xml  { head :ok }
    end

  end

  def copy_to_stock
    puts "----------------------------------------------------------------------"
    puts params[:id]

    @az_struct_data_type = AzStructDataType.find(params[:id])

    struct = @az_struct_data_type.make_copy_data_type(@az_struct_data_type.owner, nil)

    puts "----------------------------------------------------------------------"

    respond_to do |format|
      format.html { redirect_to(:action => 'edit', :id => struct.id) }
      format.xml  { head :ok }
    end
  end

  def info_tooltip
    @struct_data_type = AzStructDataType.find(params[:id])
    respond_to do |format|
      format.html { render :partial => "az_struct_data_types/tooltips/show_struct_info", :locals => {:az_struct_data_type => @struct_data_type} }
    end
  end

  def variables_list
    @struct_data_type = AzStructDataType.find(params[:id])
    respond_to do |format|
      format.html { render :partial => "az_struct_data_types/variables_list1", :locals => {:struct => @struct_data_type, :permitted_to_edit => true} }
    end
  end

  def move_up
    struct = AzStructDataType.find(params[:id])
    struct.move_up
    respond_to do |format|
      format.html { redirect_to(:back) }
    end
  end

  def move_down
    struct = AzStructDataType.find(params[:id])
    struct.move_down
    respond_to do |format|
      format.html { redirect_to(:back) }
    end
  end
  
  def move_up_tr
    struct = AzStructDataType.find(params[:id])
    positions = params[:positions]
    struct_and_position = parse_positions(positions)

    move_up_down(struct, struct_and_position, -1, "tr_position")

    respond_to do |format|
      format.html { render :text => "ok" }
    end
  end

  def move_down_tr
    struct = AzStructDataType.find(params[:id])
    positions = params[:positions]
    struct_and_position = parse_positions(positions)
    move_up_down(struct, struct_and_position, 1, "tr_position")

    respond_to do |format|
      format.html { render :text => "ok" }
    end
  end

  def parse_positions(positions)
    struct_position = positions.split(';')
    struct_and_position = []
    position = 0
    struct_position.each do |pp|
      struct_id = pp
      position += 1
      struct_and_position << [position, Integer(struct_id)]
    end
    struct_and_position.sort{|a, b| a[0] <=> b[0]}
    return struct_and_position
  end
  
  def move_up_down(struct, struct_and_position, direction, position_field_name)
    move_next_struct = false

    if direction == -1
      struct_and_position.sort!{|a, b| b[0] <=> a[0]}
    end

    if struct.id == struct_and_position[struct_and_position.size - 1][1]
      # Если сдвиг вниз и сдвигаемея страница последняя - ничего не делаем
      # Если сдвиг вверх и сдвигаемая страница первая - ничего не делаем
      #puts "RETURN ==========================================================================="
      return
    end

    #puts "==========================================================================="
    #puts struct_and_position.inspect

    struct_and_position.each do |pnp|

      struct_pos = pnp[0]
      struct_id = pnp[1]

      st = AzStructDataType.find(struct_id)

      if struct.id == struct_id
        #pg.position = struct_pos + direction
        st[position_field_name] = struct_pos + direction
        move_next_struct = true
      elsif move_next_struct
        #pg.position = struct_pos - direction
        st[position_field_name] = struct_pos - direction
        move_next_struct = false
      else
        #pg.position = struct_pos
        st[position_field_name] = struct_pos
      end
      #puts "position = #{position} pg.position = #{pg.position}"
      st.save
    end
  end


  def status_dialog
    st = AzStructDataType.find(params[:id])
    update_url = {:controller => "az_struct_data_types", :action => "update_status", :id => st.id}
    statuses = st.statuses_for_select
    locals = {:entity => st, :update_url => update_url, :statuses => statuses}

    respond_to do |format|
      format.html { render :partial => '/az_base_projects/tr_edit/tr_edit_status_dialog_container', :locals => locals }
    end
  end

  def update_status
    st = AzStructDataType.find(params[:id])
    st.status = params["az_struct_data_type"]["status"]
    ret = st.save
    controller = st.az_base_project.class.to_s.underscore.pluralize
    respond_to do |format|
      if ret
        format.html { render :text => "<script type='text/javascript'>Windows.closeAll(); update_structs_validatots_in_tr();</script>" }
      else
        update_url = {:controller => 'az_definitions', :action => "update_description", :id => st.id}
        statuses = st.statuses_for_select
        locals = { :entity => st, :update_url => update_url, :statuses => statuses}
        format.html { render :partial => '/az_base_projects/tr_edit/tr_edit_status_dialog_container', :locals => locals }
      end
    end
  end

end
