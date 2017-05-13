class AzProjectStatusesController < ApplicationController

  layout "main"

  filter_access_to :all

  # GET /az_project_statuses
  # GET /az_project_statuses.xml
  def index
    @az_project_statuses = AzProjectStatus.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @az_project_statuses }
    end
  end

  # GET /az_project_statuses/1
  # GET /az_project_statuses/1.xml
  def show
    @az_project_status = AzProjectStatus.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @az_project_status }
    end
  end

  # GET /az_project_statuses/new
  # GET /az_project_statuses/new.xml
  def new
    @az_project_status = AzProjectStatus.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @az_project_status }
    end
  end

  # GET /az_project_statuses/1/edit
  def edit
    @az_project_status = AzProjectStatus.find(params[:id])
  end

  # POST /az_project_statuses
  # POST /az_project_statuses.xml
  def create
    @az_project_status = AzProjectStatus.new(params[:az_project_status])
    @az_project_status.owner_id = 1 #TODO нужен ли owner_id? Или понадобится в будущем, когда всем понадобятся свои статусы? Синхронизировать статусы с редмайном?
    respond_to do |format|
      if @az_project_status.save
        flash[:notice] = 'AzProjectStatus was successfully created.'
        format.html { redirect_to(@az_project_status) }
        format.xml  { render :xml => @az_project_status, :status => :created, :location => @az_project_status }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @az_project_status.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /az_project_statuses/1
  # PUT /az_project_statuses/1.xml
  def update
    @az_project_status = AzProjectStatus.find(params[:id])

    respond_to do |format|
      if @az_project_status.update_attributes(params[:az_project_status])
        flash[:notice] = 'AzProjectStatus was successfully updated.'
        format.html { redirect_to(@az_project_status) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @az_project_status.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /az_project_statuses/1
  # DELETE /az_project_statuses/1.xml
  def destroy
    @az_project_status = AzProjectStatus.find(params[:id])
    @az_project_status.destroy

    respond_to do |format|
      format.html { redirect_to(az_project_statuses_url) }
      format.xml  { head :ok }
    end
  end
end
