class AzTypedPageOperationsController < ApplicationController
  
  filter_access_to :all

  layout "main"

  # GET /az_typed_page_operations
  # GET /az_typed_page_operations.xml
  def index
    @az_typed_page_operations = AzTypedPageOperation.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @az_typed_page_operations }
    end
  end

  # GET /az_typed_page_operations/1
  # GET /az_typed_page_operations/1.xml
#  def show
#    @az_typed_page_operation = AzTypedPageOperation.find(params[:id])
#
#    respond_to do |format|
#      format.html # show.html.erb
#      format.xml  { render :xml => @az_typed_page_operation }
#    end
#  end

  # GET /az_typed_page_operations/new
  # GET /az_typed_page_operations/new.xml
#  def new
#    @az_typed_page_operation = AzTypedPageOperation.new
#
#    respond_to do |format|
#      format.html # new.html.erb
#      format.xml  { render :xml => @az_typed_page_operation }
#    end
#  end

  # GET /az_typed_page_operations/1/edit
#  def edit
#    @az_typed_page_operation = AzTypedPageOperation.find(params[:id])
#  end

  # POST /az_typed_page_operations
  # POST /az_typed_page_operations.xml
  def create
    result = true
    project = nil

    az_typed_page_id = params[:az_typed_page_operation][:az_typed_page_id]
    az_operation_time_id = params[:az_typed_page_operation][:az_operation_time_id]

    @az_typed_page_operations = AzTypedPageOperation.find(:all, :conditions => {:az_typed_page_id => az_typed_page_id, :az_operation_time_id => az_operation_time_id})

    if @az_typed_page_operations.size > 0
      @az_typed_page_operations.each do |tpop|
        tpop.destroy
      end
      project = @az_typed_page_operations[0].az_typed_page.az_page.get_project
      #az_typed_page  az_operation_time
    else
      @az_typed_page_operation = AzTypedPageOperation.new(params[:az_typed_page_operation])
      result = @az_typed_page_operation.save
      project = @az_typed_page_operation.az_typed_page.az_page.get_project
    end

    respond_to do |format|
      if result
        flash[:notice] = 'AzTypedPageOperation was successfully created.'
        format.html { redirect_to(project) }
        format.xml  { render :xml => @az_typed_page_operation, :status => :created, :location => @az_typed_page_operation }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @az_typed_page_operation.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /az_typed_page_operations/1
  # PUT /az_typed_page_operations/1.xml
#  def update
#    @az_typed_page_operation = AzTypedPageOperation.find(params[:id])
#
#    respond_to do |format|
#      if @az_typed_page_operation.update_attributes(params[:az_typed_page_operation])
#        flash[:notice] = 'AzTypedPageOperation was successfully updated.'
#        format.html { redirect_to(@az_typed_page_operation) }
#        format.xml  { head :ok }
#      else
#        format.html { render :action => "edit" }
#        format.xml  { render :xml => @az_typed_page_operation.errors, :status => :unprocessable_entity }
#      end
#    end
#  end
#
#  # DELETE /az_typed_page_operations/1
#  # DELETE /az_typed_page_operations/1.xml
#  def destroy
#    @az_typed_page_operation = AzTypedPageOperation.find(params[:id])
#    @az_typed_page_operation.destroy
#
#    respond_to do |format|
#      format.html { redirect_to(az_typed_page_operations_url) }
#      format.xml  { head :ok }
#    end
#  end
end
