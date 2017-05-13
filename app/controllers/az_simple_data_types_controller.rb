class AzSimpleDataTypesController < ApplicationController

  filter_access_to :all

  layout "main"

  # GET /az_simple_data_types
  # GET /az_simple_data_types.xml
  def index
    @az_simple_data_types = AzSimpleDataType.all
    @title = 'Простые типы данных'
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @az_simple_data_types }
    end
  end

  # GET /az_simple_data_types/1
  # GET /az_simple_data_types/1.xml
  def show
    @az_simple_data_type = AzSimpleDataType.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @az_simple_data_type }
    end
  end

  # GET /az_simple_data_types/new
  # GET /az_simple_data_types/new.xml
  def new
    @az_simple_data_type = AzSimpleDataType.new
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @az_simple_data_type }
    end
  end

  # GET /az_simple_data_types/1/edit
  def edit
    @az_simple_data_type = AzSimpleDataType.find(params[:id])
    @title = 'Простой тип данных "' + @az_simple_data_type.name + '"'
  end

  # POST /az_simple_data_types
  # POST /az_simple_data_types.xml
  def create
    @az_simple_data_type = AzSimpleDataType.new(params[:az_simple_data_type])

    respond_to do |format|
      if @az_simple_data_type.save
        flash[:notice] = 'AzSimpleDataType was successfully created.'
        format.html { redirect_to(@az_simple_data_type) }
        format.xml  { render :xml => @az_simple_data_type, :status => :created, :location => @az_simple_data_type }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @az_simple_data_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /az_simple_data_types/1
  # PUT /az_simple_data_types/1.xml
  def update
    @az_simple_data_type = AzSimpleDataType.find(params[:id])

    respond_to do |format|
      if @az_simple_data_type.update_attributes(params[:az_simple_data_type])
        flash[:notice] = 'AzSimpleDataType was successfully updated.'
        format.html { redirect_to(@az_simple_data_type) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @az_simple_data_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /az_simple_data_types/1
  # DELETE /az_simple_data_types/1.xml
  def destroy
    @az_simple_data_type = AzSimpleDataType.find(params[:id])
    @az_simple_data_type.destroy

    respond_to do |format|
      format.html { redirect_to(az_simple_data_types_url) }
      format.xml  { head :ok }
    end
  end
end
