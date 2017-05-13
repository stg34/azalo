class AzCommonsController < ApplicationController

  layout 'main'

  filter_access_to :index_user, :new, :create, :tr_new_dialog, :tr_create
  filter_access_to :all, :attribute_check => true

  def index
    @commons_class = get_class(params)
    @az_commons = @commons_class.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @az_commons }
    end
  end

    # GET /az_commons
  # GET /az_commons.xml
  def index_user

    @commons_class = get_class(params)
    @my_companies = current_user.my_works
    @commons = @commons_class.get_by_companies(@my_companies)
    @title = @commons_class.get_label

    respond_to do |format|
      format.html { render :template => 'az_commons/index_user'}
      #format.xml  { render :xml => @az_commons }
    end
  end


  # GET /az_commons/new
  # GET /az_commons/new.xml
  def new
    @az_common = get_class(params).new
    @az_common.owner_id = params[:owner_id]
    @az_common.az_base_project_id = params[:az_base_project_id]

    prepare_new_data(@az_common)

    respond_to do |format|
      format.html  { render :template => 'az_commons/new'}
      format.xml  { render :xml => @az_common }
    end
  end

  def tr_new_dialog
    puts "tr_new_dialog ============================================"
    common = get_class(params).new
    common.az_base_project_id = params[:az_base_project_id]
    url = {:controller => params[:controller], :action => :tr_create, :owner_id => params[:owner_id]}
    locals = { :common => common, :url => url}
    respond_to do |format|
      format.html { render :partial => '/az_base_projects/tr_edit/tr_edit_common_dialog_container', :locals => locals }
    end
  end

  def tr_create
    common = get_class(params).new
    p = params[:controller].singularize
    common.description = params[p]['description']
    common.name = params[p]['name']
    common.owner_id = params['owner_id']
    common.az_base_project_id = params[p]['az_base_project_id']

    ret = common.save
    #controller = params[:controller]
    prj_controller = common.az_base_project.class.to_s.underscore.pluralize
    respond_to do |format|
      if ret
        format.html { render :text => "<script type='text/javascript'>Windows.closeAll(); update_commons_in_tr('#{params[:controller]}');</script>" }
      else
        url = {:controller => params[:controller], :action => :tr_create, :owner_id => params[:owner_id]}
        locals = { :common => common, :url => url}
        format.html { render :partial => '/az_base_projects/tr_edit/tr_edit_common_dialog_container', :locals => locals }
      end
    end
  end

  # POST /az_commons
  # POST /az_commons.xml
#  def create
#    @az_common = get_class(params).new(params[params[:controller].singularize])
#
#    respond_to do |format|
#      if @az_common.save
#        flash[:notice] = 'Запись успешно создана.'
#        format.html { redirect_to(@az_common) }
#        format.xml  { render :xml => @az_common, :status => :created, :location => @az_common }
#      else
#        #format.html { render :action => "new" }
#        format.html { render :action => "new", :template => 'az_commons/new'}
#        format.xml  { render :xml => @az_common.errors, :status => :unprocessable_entity }
#      end
#    end
#  end

  # GET /az_commons/1/edit
  def edit
    @az_common = get_class(params).find(params[:id])
    @title = @az_common.class.get_label
    @statuses = @az_common.statuses_for_select

    respond_to do |format|
      format.html  { render :template => 'az_commons/edit'}
    end
  end

  # POST /az_commons
  # POST /az_commons.xml
  def create
    @az_common = get_class(params).new(params[params[:controller].singularize])

    respond_to do |format|
      if @az_common.save
        flash[:notice] = 'Запись успешно создана.'
        format.html { redirect_to(@az_common) }
        format.xml  { render :xml => @az_common, :status => :created, :location => @az_common }
      else
        prepare_new_data(@az_common)
        format.html { render :action => "new", :template => 'az_commons/new'}
        format.xml  { render :xml => @az_common.errors, :status => :unprocessable_entity }
      end
    end
  end


  def update
    @az_common = get_class(params).find(params[:id])

    respond_to do |format|
      if @az_common.update_attributes(params[params[:controller].singularize])
        flash[:notice] = 'Запсиь успешно обновлена.'
        format.html { redirect_to(@az_common) }
        format.xml  { head :ok }
      else
        format.html  { render :template => 'az_commons/edit'}
        format.xml  { render :xml => @az_common.errors, :status => :unprocessable_entity }
      end
    end
  end

  def show
    @az_common = get_class(params).find(params[:id])
    @title = @az_common.class.get_label
    respond_to do |format|
      format.html  { render :template => 'az_commons/show'}
    end
  end

  # DELETE /az_commons/1
  # DELETE /az_commons/1.xml
  def destroy
    @az_common = get_class(params).find(params[:id])
    @az_common.destroy

    respond_to do |format|
      format.html { redirect_to(:action => 'index_user') }
      format.xml  { head :ok }
    end
  end

  def tr_up
    #@az_common = get_class(params).find(params[:id])
    respond_to do |format|
      format.html { render :text => 'ok' }
    end
  end

  def move_up
    common = AzCommon.find(params[:id])
    common.move_up
    respond_to do |format|
      format.html { redirect_to(:back) }
    end
  end

  def move_down
    common = AzCommon.find(params[:id])
    common.move_down
    respond_to do |format|
      format.html { redirect_to(:back) }
    end
  end

#  def move_up_tr
#    common = AzCommon.find(params[:id])
#    common.move_up
#    respond_to do |format|
#      format.html { render :text => 'ok' }
#    end
#  end

#  def move_down_tr
#    common = AzCommon.find(params[:id])
#    common.move_down
#    respond_to do |format|
#      format.html { render :text => 'ok' }
#    end
#  end

  def description_text_dialog
    common = AzCommon.find(params[:id])
    update_url = {:controller => params[:controller], :action => "update_description", :id => common.id}
    locals = { :entity => common, :field => :description, :update_url => update_url}
    respond_to do |format|
      format.html { render :partial => '/az_base_projects/tr_edit/tr_edit_text_dialog_container', :locals => locals }
    end
  end

  def status_dialog
    common = AzCommon.find(params[:id])
    update_url = {:controller => params[:controller], :action => "update_status", :id => common.id}
    statuses = common.statuses_for_select
    locals = { :entity => common, :update_url => update_url, :statuses => statuses}
    
    respond_to do |format|
      format.html { render :partial => '/az_base_projects/tr_edit/tr_edit_status_dialog_container', :locals => locals }
    end
  end

  def update_description
    common = AzCommon.find(params[:id])
    common.description = params[params[:controller].singularize]["description"]
    ret = common.save
    controller = params[:controller]
    respond_to do |format|
      if ret
        format.html { render :text => "<script type='text/javascript'>Windows.closeAll(); update_commons_in_tr('#{controller}');</script>" }
      else
        update_url = {:controller => params[:controller], :action => "update_description", :id => common.id}
        locals = { :entity => common, :field => :description, :update_url => update_url}
        format.html { render :partial => '/az_base_projects/tr_edit/tr_edit_text_dialog', :locals => locals }
      end
    end
  end

  def update_status
    common = AzCommon.find(params[:id])
    common.status = params[params[:controller].singularize]["status"]
    ret = common.save
    controller = params[:controller]
    respond_to do |format|
      if ret
        format.html { render :text => "<script type='text/javascript'>Windows.closeAll(); update_commons_in_tr('#{controller}');</script>" }
      else
        update_url = {:controller => params[:controller], :action => "update_status", :id => common.id}
        statuses = common.statuses_for_select
        locals = { :entity => common, :update_url => update_url, :statuses => statuses}
        format.html { render :partial => '/az_base_projects/tr_edit/tr_edit_status_dialog_container', :locals => locals }
      end
    end
  end
  private

  def prepare_new_data(az_common)
    @title = az_common.class.get_label
    @statuses = az_common.statuses_for_select
  end
  
end
