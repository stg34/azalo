class AzPageAzPageTypesController < ApplicationController

  filter_access_to :all

  layout 'main'

  # GET /az_page_az_page_types
  # GET /az_page_az_page_types.xml
  def index
    @az_page_az_page_types = AzPageAzPageType.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @az_page_az_page_types }
    end
  end

  # GET /az_page_az_page_types/1
  # GET /az_page_az_page_types/1.xml
  def show
    @az_page_az_page_type = AzPageAzPageType.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @az_page_az_page_type }
    end
  end

  # GET /az_page_az_page_types/new
  # GET /az_page_az_page_types/new.xml
  def new
    @az_page_az_page_type = AzPageAzPageType.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @az_page_az_page_type }
    end
  end

  # GET /az_page_az_page_types/1/edit
  def edit
    @az_page_az_page_type = AzPageAzPageType.find(params[:id])
  end

  # POST /az_page_az_page_types
  # POST /az_page_az_page_types.xml
  def create
    @az_page_az_page_type = AzPageAzPageType.new(params[:az_page_az_page_type])

    respond_to do |format|
      if @az_page_az_page_type.save
        flash[:notice] = 'AzPageAzPageType was successfully created.'
        format.html { redirect_to(@az_page_az_page_type) }
        format.xml  { render :xml => @az_page_az_page_type, :status => :created, :location => @az_page_az_page_type }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @az_page_az_page_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /az_page_az_page_types/1
  # PUT /az_page_az_page_types/1.xml
  def update
    @az_page_az_page_type = AzPageAzPageType.find(params[:id])

    respond_to do |format|
      if @az_page_az_page_type.update_attributes(params[:az_page_az_page_type])
        flash[:notice] = 'AzPageAzPageType was successfully updated.'
        format.html { redirect_to(@az_page_az_page_type) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @az_page_az_page_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /az_page_az_page_types/1
  # DELETE /az_page_az_page_types/1.xml
  def destroy
    @az_page_az_page_type = AzPageAzPageType.find(params[:id])
    @az_page_az_page_type.destroy

    respond_to do |format|
      format.html { redirect_to(az_page_az_page_types_url) }
      format.xml  { head :ok }
    end
  end
end
