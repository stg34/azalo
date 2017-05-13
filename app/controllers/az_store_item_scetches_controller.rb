class AzStoreItemScetchesController < ApplicationController

  filter_access_to :index, :new, :create
  filter_access_to :all, :attribute_check => true

  layout "main"

  # GET /az_store_item_scetches
  # GET /az_store_item_scetches.xml
  def index
    @az_store_item_scetches = AzStoreItemScetch.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @az_store_item_scetches }
    end
  end

  # GET /az_store_item_scetches/1
  # GET /az_store_item_scetches/1.xml
  def show
    @az_store_item_scetch = AzStoreItemScetch.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @az_store_item_scetch }
    end
  end

  # GET /az_store_item_scetches/new
  # GET /az_store_item_scetches/new.xml
  def new
    @az_store_item_scetch = AzStoreItemScetch.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @az_store_item_scetch }
    end
  end

  # GET /az_store_item_scetches/1/edit
  def edit
    @az_store_item_scetch = AzStoreItemScetch.find(params[:id])
  end

  # POST /az_store_item_scetches
  # POST /az_store_item_scetches.xml
  def create
    @az_store_item_scetch = AzStoreItemScetch.new(params[:az_store_item_scetch])

    respond_to do |format|
      if @az_store_item_scetch.save
        format.html { redirect_to(@az_store_item_scetch, :notice => 'AzStoreItemScetch was successfully created.') }
        format.xml  { render :xml => @az_store_item_scetch, :status => :created, :location => @az_store_item_scetch }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @az_store_item_scetch.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /az_store_item_scetches/1
  # PUT /az_store_item_scetches/1.xml
  def update
    @az_store_item_scetch = AzStoreItemScetch.find(params[:id])

    respond_to do |format|
      if @az_store_item_scetch.update_attributes(params[:az_store_item_scetch])
        format.html { redirect_to(@az_store_item_scetch, :notice => 'AzStoreItemScetch was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @az_store_item_scetch.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /az_store_item_scetches/1
  # DELETE /az_store_item_scetches/1.xml
  def destroy
    @az_store_item_scetch = AzStoreItemScetch.find(params[:id])
    @az_store_item_scetch.destroy

    respond_to do |format|
      format.html { redirect_to(az_store_item_scetches_url) }
      format.xml  { head :ok }
    end
  end
end
