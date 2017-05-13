class AzWarningPeriodsController < ApplicationController
  # GET /az_warning_periods
  # GET /az_warning_periods.xml

  filter_access_to :all

  layout "main"

  def index
    @az_warning_periods = AzWarningPeriod.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @az_warning_periods }
    end
  end

  # GET /az_warning_periods/1
  # GET /az_warning_periods/1.xml
  def show
    @az_warning_period = AzWarningPeriod.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @az_warning_period }
    end
  end

  # GET /az_warning_periods/new
  # GET /az_warning_periods/new.xml
  def new
    @az_warning_period = AzWarningPeriod.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @az_warning_period }
    end
  end

  # GET /az_warning_periods/1/edit
  def edit
    @az_warning_period = AzWarningPeriod.find(params[:id])
  end

  # POST /az_warning_periods
  # POST /az_warning_periods.xml
  def create
    @az_warning_period = AzWarningPeriod.new(params[:az_warning_period])

    respond_to do |format|
      if @az_warning_period.save
        format.html { redirect_to(@az_warning_period, :notice => 'AzWarningPeriod was successfully created.') }
        format.xml  { render :xml => @az_warning_period, :status => :created, :location => @az_warning_period }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @az_warning_period.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /az_warning_periods/1
  # PUT /az_warning_periods/1.xml
  def update
    @az_warning_period = AzWarningPeriod.find(params[:id])

    respond_to do |format|
      if @az_warning_period.update_attributes(params[:az_warning_period])
        format.html { redirect_to(@az_warning_period, :notice => 'AzWarningPeriod was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @az_warning_period.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /az_warning_periods/1
  # DELETE /az_warning_periods/1.xml
  def destroy
    @az_warning_period = AzWarningPeriod.find(params[:id])
    @az_warning_period.destroy

    respond_to do |format|
      format.html { redirect_to(az_warning_periods_url) }
      format.xml  { head :ok }
    end
  end
end
