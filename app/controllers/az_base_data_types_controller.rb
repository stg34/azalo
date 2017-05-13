class AzBaseDataTypesController < ApplicationController

  layout "main"

  #filter_access_to :index_user
  filter_access_to :all, :attribute_check => true

  # GET /az_base_data_types
  # GET /az_base_data_types.xml
  def index
    @az_base_data_types = AzBaseDataType.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @az_base_data_types }
    end
  end

  # GET /az_base_data_types/1
  # GET /az_base_data_types/1.xml
  def show
    @az_base_data_type = AzBaseDataType.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @az_base_data_type }
    end
  end

  # GET /az_base_data_types/new
  # GET /az_base_data_types/new.xml
  def new
    @az_base_data_type = AzBaseDataType.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @az_base_data_type }
    end
  end

  # GET /az_base_data_types/1/edit
  def edit
    @az_base_data_type = AzBaseDataType.find(params[:id])
  end

  # POST /az_base_data_types
  # POST /az_base_data_types.xml
  def create
    @az_base_data_type = AzBaseDataType.new(params[:az_base_data_type])

    respond_to do |format|
      if @az_base_data_type.save
        flash[:notice] = 'AzBaseDataType was successfully created.'
        format.html { redirect_to(@az_base_data_type) }
        format.xml  { render :xml => @az_base_data_type, :status => :created, :location => @az_base_data_type }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @az_base_data_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /az_base_data_types/1
  # PUT /az_base_data_types/1.xml
  def update
    @az_base_data_type = AzBaseDataType.find(params[:id])

    respond_to do |format|
      if @az_base_data_type.update_attributes(params[:az_base_data_type])
        flash[:notice] = 'AzBaseDataType was successfully updated.'
        format.html { redirect_to(@az_base_data_type) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @az_base_data_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /az_base_data_types/1
  # DELETE /az_base_data_types/1.xml
  def destroy
    @az_base_data_type = AzBaseDataType.find(params[:id])
    @az_base_data_type.destroy

    respond_to do |format|
      format.html { redirect_to(az_base_data_types_url) }
      format.xml  { head :ok }
    end
  end
end
