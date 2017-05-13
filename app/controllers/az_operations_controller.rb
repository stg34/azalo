class AzOperationsController < ApplicationController

  filter_access_to :all

  layout "main"

  # GET /az_operations
  # GET /az_operations.xml
  def index
    @az_operations = AzOperation.all
    @title = 'Операции'

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @az_operations }
    end
  end

  # GET /az_operations/1
  # GET /az_operations/1.xml
  def show
    @az_operation = AzOperation.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @az_operation }
    end
  end

  # GET /az_operations/new
  # GET /az_operations/new.xml
  def new
    @az_operation = AzOperation.new
    @title = 'Новая операция'
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @az_operation }
    end
  end

  # GET /az_operations/1/edit
  def edit
    @az_operation = AzOperation.find(params[:id])
    @title = 'Операция "' + @az_operation.name + '"'
  end

  # POST /az_operations
  # POST /az_operations.xml
  def create
    @az_operation = AzOperation.new(params[:az_operation])

    respond_to do |format|
      if @az_operation.save
        flash[:notice] = 'AzOperation was successfully created.'
        format.html { redirect_to(@az_operation) }
        format.xml  { render :xml => @az_operation, :status => :created, :location => @az_operation }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @az_operation.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /az_operations/1
  # PUT /az_operations/1.xml
  def update
    @az_operation = AzOperation.find(params[:id])

    respond_to do |format|
      if @az_operation.update_attributes(params[:az_operation])
        flash[:notice] = 'AzOperation was successfully updated.'
        format.html { redirect_to(edit_az_operation_path(@az_operation)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @az_operation.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /az_operations/1
  # DELETE /az_operations/1.xml
  def destroy
    @az_operation = AzOperation.find(params[:id])
    @az_operation.destroy

    respond_to do |format|
      format.html { redirect_to(az_operations_url) }
      format.xml  { head :ok }
    end
  end
end
