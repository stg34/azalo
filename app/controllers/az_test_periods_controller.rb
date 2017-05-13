class AzTestPeriodsController < ApplicationController

  filter_access_to :all

  layout "main"

  # GET /az_test_periods
  # GET /az_test_periods.xml
  def index
    az_test_periods = AzTestPeriod.find(:all, :order => 'ends_at desc')
    @az_test_periods = az_test_periods.select{|tp| tp.az_company.az_tariff.price > 0}

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @az_test_periods }
    end
  end

  # GET /az_test_periods/1
  # GET /az_test_periods/1.xml
  def show
    @az_test_period = AzTestPeriod.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @az_test_period }
    end
  end

  # GET /az_test_periods/new
  # GET /az_test_periods/new.xml
  def new
    @az_test_period = AzTestPeriod.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @az_test_period }
    end
  end

  # GET /az_test_periods/1/edit
  def edit
    @az_test_period = AzTestPeriod.find(params[:id])
  end

  # POST /az_test_periods
  # POST /az_test_periods.xml
  def create
    @az_test_period = AzTestPeriod.new(params[:az_test_period])

    respond_to do |format|
      if @az_test_period.save
        format.html { redirect_to(@az_test_period, :notice => 'AzTestPeriod was successfully created.') }
        format.xml  { render :xml => @az_test_period, :status => :created, :location => @az_test_period }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @az_test_period.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /az_test_periods/1
  # PUT /az_test_periods/1.xml
  def update
    @az_test_period = AzTestPeriod.find(params[:id])

    respond_to do |format|
      if @az_test_period.update_attributes(params[:az_test_period])
        format.html { redirect_to(@az_test_period, :notice => 'AzTestPeriod was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @az_test_period.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /az_test_periods/1
  # DELETE /az_test_periods/1.xml
  def destroy
    @az_test_period = AzTestPeriod.find(params[:id])
    @az_test_period.destroy

    respond_to do |format|
      format.html { redirect_to(az_test_periods_url) }
      format.xml  { head :ok }
    end
  end
end
