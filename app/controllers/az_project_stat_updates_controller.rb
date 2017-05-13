class AzProjectStatUpdatesController < ApplicationController
  # GET /az_project_stat_updates
  # GET /az_project_stat_updates.xml
  def index
    @az_project_stat_updates = AzProjectStatUpdate.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @az_project_stat_updates }
    end
  end

  # GET /az_project_stat_updates/1
  # GET /az_project_stat_updates/1.xml
  def show
    @az_project_stat_update = AzProjectStatUpdate.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @az_project_stat_update }
    end
  end

  # GET /az_project_stat_updates/new
  # GET /az_project_stat_updates/new.xml
  def new
    @az_project_stat_update = AzProjectStatUpdate.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @az_project_stat_update }
    end
  end

  # GET /az_project_stat_updates/1/edit
  def edit
    @az_project_stat_update = AzProjectStatUpdate.find(params[:id])
  end

  # POST /az_project_stat_updates
  # POST /az_project_stat_updates.xml
  def create
    @az_project_stat_update = AzProjectStatUpdate.new(params[:az_project_stat_update])

    respond_to do |format|
      if @az_project_stat_update.save
        format.html { redirect_to(@az_project_stat_update, :notice => 'AzProjectStatUpdate was successfully created.') }
        format.xml  { render :xml => @az_project_stat_update, :status => :created, :location => @az_project_stat_update }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @az_project_stat_update.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /az_project_stat_updates/1
  # PUT /az_project_stat_updates/1.xml
  def update
    @az_project_stat_update = AzProjectStatUpdate.find(params[:id])

    respond_to do |format|
      if @az_project_stat_update.update_attributes(params[:az_project_stat_update])
        format.html { redirect_to(@az_project_stat_update, :notice => 'AzProjectStatUpdate was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @az_project_stat_update.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /az_project_stat_updates/1
  # DELETE /az_project_stat_updates/1.xml
  def destroy
    @az_project_stat_update = AzProjectStatUpdate.find(params[:id])
    @az_project_stat_update.destroy

    respond_to do |format|
      format.html { redirect_to(az_project_stat_updates_url) }
      format.xml  { head :ok }
    end
  end
end
