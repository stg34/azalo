class AzTariffsController < ApplicationController

  layout "main"

  filter_access_to :all

  # GET /az_tariffs
  # GET /az_tariffs.xml
  def index
    @az_tariffs = AzTariff.find(:all, :order => 'position')

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @az_tariffs }
    end
  end

  # GET /az_tariffs/1
  # GET /az_tariffs/1.xml
  def show
    @az_tariff = AzTariff.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @az_tariff }
    end
  end

  # GET /az_tariffs/new
  # GET /az_tariffs/new.xml
  def new
    @az_tariff = AzTariff.new
    @tariff_types = AzTariff::Tariff_types
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @az_tariff }
    end
  end

  # GET /az_tariffs/1/edit
  def edit
    @tariff_types = AzTariff::Tariff_types
    @az_tariff = AzTariff.find(params[:id])
  end

  # POST /az_tariffs
  # POST /az_tariffs.xml
  def create
    @az_tariff = AzTariff.new(params[:az_tariff])

    respond_to do |format|
      if @az_tariff.save
        format.html { redirect_to(@az_tariff, :notice => 'AzTariff was successfully created.') }
        format.xml  { render :xml => @az_tariff, :status => :created, :location => @az_tariff }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @az_tariff.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /az_tariffs/1
  # PUT /az_tariffs/1.xml
  def update
    @az_tariff = AzTariff.find(params[:id])

    respond_to do |format|
      if @az_tariff.update_attributes(params[:az_tariff])
        format.html { redirect_to(@az_tariff, :notice => 'AzTariff was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @az_tariff.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /az_tariffs/1
  # DELETE /az_tariffs/1.xml
  def destroy
    @az_tariff = AzTariff.find(params[:id])
    @az_tariff.destroy

    respond_to do |format|
      format.html { redirect_to(az_tariffs_url) }
      format.xml  { head :ok }
    end
  end
end
