class AzAllowedOperationsController < ApplicationController

  layout "main"

  filter_access_to :all

  # GET /az_allowed_operations
  # GET /az_allowed_operations.xml
  def index
    @az_allowed_operations = AzAllowedOperation.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @az_allowed_operations }
    end
  end

#  # GET /az_allowed_operations/1
#  # GET /az_allowed_operations/1.xml
#  def show
#    @az_allowed_operation = AzAllowedOperation.find(params[:id])
#
#    respond_to do |format|
#      format.html # show.html.erb
#      format.xml  { render :xml => @az_allowed_operation }
#    end
#  end
#
#  # GET /az_allowed_operations/new
#  # GET /az_allowed_operations/new.xml
#  def new
#    @az_allowed_operation = AzAllowedOperation.new
#
#    respond_to do |format|
#      format.html # new.html.erb
#      format.xml  { render :xml => @az_allowed_operation }
#    end
#  end
#
#  # GET /az_allowed_operations/1/edit
#  def edit
#    @az_allowed_operation = AzAllowedOperation.find(params[:id])
#  end

  # POST /az_allowed_operations
  # POST /az_allowed_operations.xml
  def create
    result = true

    az_typed_page_id = params[:az_allowed_operation][:az_typed_page_id]
    az_operation_id = params[:az_allowed_operation][:az_operation_id]

    # TODO check if page exists
    az_typed_page = AzTypedPage.find(az_typed_page_id)
    page = AzPage.find(az_typed_page.az_page_id)

    @az_allowed_operations = AzAllowedOperation.find(:all, :conditions => {:az_typed_page_id => az_typed_page_id, :az_operation_id => az_operation_id})

    if @az_allowed_operations.size > 0
      @az_allowed_operations.each do |aop|
        aop.destroy
      end
    else
      @az_allowed_operation = AzAllowedOperation.new(params[:az_allowed_operation])
      @az_allowed_operation.owner_id = page.owner_id
      result = @az_allowed_operation.save
    end

    respond_to do |format|
      if result
        #format.html { render(:text => 'OK')}
        format.html { render(:partial => '/az_pages/show_page_box_content', :locals => {:page => page, :project => page.get_project})}
        format.xml  { render :xml => @az_allowed_operation, :status => :created, :location => @az_allowed_operation }
      else
        format.html { render :text => "Error" }
        format.xml  { render :xml => @az_allowed_operation.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /az_allowed_operations/1
  # PUT /az_allowed_operations/1.xml
#  def update
#    @az_allowed_operation = AzAllowedOperation.find(params[:id])
#
#    respond_to do |format|
#      if @az_allowed_operation.update_attributes(params[:az_allowed_operation])
#        flash[:notice] = 'AzAllowedOperation was successfully updated.'
#        format.html { redirect_to(@az_allowed_operation) }
#        format.xml  { head :ok }
#      else
#        format.html { render :action => "edit" }
#        format.xml  { render :xml => @az_allowed_operation.errors, :status => :unprocessable_entity }
#      end
#    end
#  end
#
#  # DELETE /az_allowed_operations/1
#  # DELETE /az_allowed_operations/1.xml
#  def destroy
#    @az_allowed_operation = AzAllowedOperation.find(params[:id])
#    @az_allowed_operation.destroy
#
#    respond_to do |format|
#      format.html { redirect_to(az_allowed_operations_url) }
#      format.xml  { head :ok }
#    end
#  end
end
