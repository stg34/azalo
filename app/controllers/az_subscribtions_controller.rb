class AzSubscribtionsController < ApplicationController
  # GET /az_subscribtions
  # GET /az_subscribtions.xml
  def index
    @az_subscribtions = AzSubscribtion.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @az_subscribtions }
    end
  end

  # GET /az_subscribtions/1
  # GET /az_subscribtions/1.xml
  def show
    @az_subscribtion = AzSubscribtion.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @az_subscribtion }
    end
  end

  # GET /az_subscribtions/new
  # GET /az_subscribtions/new.xml
  def new
    @az_subscribtion = AzSubscribtion.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @az_subscribtion }
    end
  end

  # GET /az_subscribtions/1/edit
  def edit
    @az_subscribtion = AzSubscribtion.find(params[:id])
  end

  # POST /az_subscribtions
  # POST /az_subscribtions.xml
  def create
    @az_subscribtion = AzSubscribtion.new(params[:az_subscribtion])

    respond_to do |format|
      if @az_subscribtion.save
        format.html { redirect_to(@az_subscribtion, :notice => 'AzSubscribtion was successfully created.') }
        format.xml  { render :xml => @az_subscribtion, :status => :created, :location => @az_subscribtion }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @az_subscribtion.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /az_subscribtions/1
  # PUT /az_subscribtions/1.xml
  def update
    @az_subscribtion = AzSubscribtion.find(params[:id])

    respond_to do |format|
      if @az_subscribtion.update_attributes(params[:az_subscribtion])
        format.html { redirect_to(@az_subscribtion, :notice => 'AzSubscribtion was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @az_subscribtion.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /az_subscribtions/1
  # DELETE /az_subscribtions/1.xml
  def destroy
    @az_subscribtion = AzSubscribtion.find(params[:id])
    @az_subscribtion.destroy

    respond_to do |format|
      format.html { redirect_to(az_subscribtions_url) }
      format.xml  { head :ok }
    end
  end
end
