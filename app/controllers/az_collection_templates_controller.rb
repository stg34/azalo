class AzCollectionTemplatesController < ApplicationController

  #filter_access_to :index_user
  filter_access_to :all, :attribute_check => true

  layout "main"

  # GET /az_collection_templates
  # GET /az_collection_templates.xml
  def index
    @az_collection_templates = AzCollectionTemplate.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @az_collection_templates }
    end
  end

  # GET /az_collection_templates/1
  # GET /az_collection_templates/1.xml
  def show
    @az_collection_template = AzCollectionTemplate.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @az_collection_template }
    end
  end

  # GET /az_collection_templates/new
  # GET /az_collection_templates/new.xml
  def new
    @az_collection_template = AzCollectionTemplate.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @az_collection_template }
    end
  end

  # GET /az_collection_templates/1/edit
  def edit
    @az_collection_template = AzCollectionTemplate.find(params[:id])
  end

  # POST /az_collection_templates
  # POST /az_collection_templates.xml
  def create
    @az_collection_template = AzCollectionTemplate.new(params[:az_collection_template])

    respond_to do |format|
      if @az_collection_template.save
        flash[:notice] = 'AzCollectionTemplate was successfully created.'
        format.html { redirect_to(@az_collection_template) }
        format.xml  { render :xml => @az_collection_template, :status => :created, :location => @az_collection_template }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @az_collection_template.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /az_collection_templates/1
  # PUT /az_collection_templates/1.xml
  def update
    @az_collection_template = AzCollectionTemplate.find(params[:id])

    respond_to do |format|
      if @az_collection_template.update_attributes(params[:az_collection_template])
        flash[:notice] = 'AzCollectionTemplate was successfully updated.'
        format.html { redirect_to(@az_collection_template) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @az_collection_template.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /az_collection_templates/1
  # DELETE /az_collection_templates/1.xml
  def destroy
    @az_collection_template = AzCollectionTemplate.find(params[:id])
    @az_collection_template.destroy

    respond_to do |format|
      format.html { redirect_to(az_collection_templates_url) }
      format.xml  { head :ok }
    end
  end
end
