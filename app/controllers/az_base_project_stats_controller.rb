class AzBaseProjectStatsController < ApplicationController
  # GET /az_base_project_stats
  # GET /az_base_project_stats.xml
  def index
    @az_base_project_stats = AzBaseProjectStat.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @az_base_project_stats }
    end
  end

  # GET /az_base_project_stats/1
  # GET /az_base_project_stats/1.xml
  def show
    @az_base_project_stat = AzBaseProjectStat.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @az_base_project_stat }
    end
  end

  # GET /az_base_project_stats/new
  # GET /az_base_project_stats/new.xml
  def new
    @az_base_project_stat = AzBaseProjectStat.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @az_base_project_stat }
    end
  end

  # GET /az_base_project_stats/1/edit
  def edit
    @az_base_project_stat = AzBaseProjectStat.find(params[:id])
  end

  # POST /az_base_project_stats
  # POST /az_base_project_stats.xml
  def create
    @az_base_project_stat = AzBaseProjectStat.new(params[:az_base_project_stat])

    respond_to do |format|
      if @az_base_project_stat.save
        format.html { redirect_to(@az_base_project_stat, :notice => 'AzBaseProjectStat was successfully created.') }
        format.xml  { render :xml => @az_base_project_stat, :status => :created, :location => @az_base_project_stat }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @az_base_project_stat.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /az_base_project_stats/1
  # PUT /az_base_project_stats/1.xml
  def update
    @az_base_project_stat = AzBaseProjectStat.find(params[:id])

    respond_to do |format|
      if @az_base_project_stat.update_attributes(params[:az_base_project_stat])
        format.html { redirect_to(@az_base_project_stat, :notice => 'AzBaseProjectStat was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @az_base_project_stat.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /az_base_project_stats/1
  # DELETE /az_base_project_stats/1.xml
  def destroy
    @az_base_project_stat = AzBaseProjectStat.find(params[:id])
    @az_base_project_stat.destroy

    respond_to do |format|
      format.html { redirect_to(az_base_project_stats_url) }
      format.xml  { head :ok }
    end
  end
end
