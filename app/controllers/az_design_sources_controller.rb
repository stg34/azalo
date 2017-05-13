class AzDesignSourcesController < ApplicationController
  # GET /az_design_sources
  # GET /az_design_sources.xml
#  def index
#    @az_design_sources = AzDesignSource.all
#
#    respond_to do |format|
#      format.html # index.html.erb
#      format.xml  { render :xml => @az_design_sources }
#    end
#  end

  # GET /az_design_sources/1
  # GET /az_design_sources/1.xml
  def show
    @source = AzDesignSource.find(params[:id])

    respond_to do |format|
      format.html { render :template => "/az_design_sources/show", :layout => "popup_iframe"}
      #format.xml  { render :xml => @source }
    end
  end

  # GET /az_design_sources/new
  # GET /az_design_sources/new.xml
  def new
    @source = AzDesignSource.new
    @source.az_design_id = params[:id]

    respond_to do |format|
      #format.xml  { render :xml => @source }
      format.html { render :template => '/az_design_sources/new', :layout => "popup_iframe"}
    end
  end

  # GET /az_design_sources/1/edit
#  def edit
#    @az_design_source = AzDesignSource.find(params[:id])
#  end

  # POST /az_design_sources
  # POST /az_design_sources.xml
  def create
    design_id = Integer(params[:az_design_source][:az_design_id])
    @source = AzDesignSource.new
    @source.source = params[:az_design_source][:source]
    @source.az_design_id = -design_id
    @source.owner_id = -design_id

    respond_to do |format|
      if @source.save
        puts "ok"
        format.html { render :template => "/az_design_sources/show", :layout => "popup_iframe"}
        #format.xml  { render :xml => @source, :status => :created, :location => @source }
      else
        puts "error"
        puts "============================"
        @source.az_design_id = -@source.az_design_id
        format.html { render :template => "/az_design_sources/new", :layout => "popup_iframe"}
      end
    end
  end

  # PUT /az_design_sources/1
  # PUT /az_design_sources/1.xml
#  def update
#    @az_design_source = AzDesignSource.find(params[:id])
#
#    respond_to do |format|
#      if @az_design_source.update_attributes(params[:az_design_source])
#        format.html { redirect_to(@az_design_source, :notice => 'AzDesignSource was successfully updated.') }
#        format.xml  { head :ok }
#      else
#        format.html { render :action => "edit" }
#        format.xml  { render :xml => @az_design_source.errors, :status => :unprocessable_entity }
#      end
#    end
#  end

  # DELETE /az_design_sources/1
  # DELETE /az_design_sources/1.xml
#  def destroy
#    @az_design_source = AzDesignSource.find(params[:id])
#    @az_design_source.destroy
#
#    respond_to do |format|
#      format.html { redirect_to(az_design_sources_url) }
#      format.xml  { head :ok }
#    end
#  end


  def destroy_by_rnd
    rnd = Integer(params[:rnd])
    @source = AzDesignSource.find_by_az_design_id(-rnd)
    if @source == nil

    else
      @source.destroy
    end

    @source = AzDesignSource.new
    @source.az_design_id = rnd

    respond_to do |format|
      format.html { render :template => "/az_design_sources/new", :layout => "popup_iframe"}
      #format.xml  { head :ok }
    end
  end
end
