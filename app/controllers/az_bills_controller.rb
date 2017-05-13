class AzBillsController < ApplicationController

  filter_access_to :all

  # GET /az_bills
  # GET /az_bills.xml
  def index
    @az_bills = AzBill.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @az_bills }
    end
  end

  # GET /az_bills/1
  # GET /az_bills/1.xml
  def show
    @az_bill = AzBill.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @az_bill }
    end
  end

  # GET /az_bills/new
  # GET /az_bills/new.xml
  def new
    @az_bill = AzBill.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @az_bill }
    end
  end

  # GET /az_bills/1/edit
  def edit
    @az_bill = AzBill.find(params[:id])
  end

  # POST /az_bills
  # POST /az_bills.xml
  def create
    @az_bill = AzBill.new(params[:az_bill])

    respond_to do |format|
      if @az_bill.save
        format.html { redirect_to(@az_bill, :notice => 'AzBill was successfully created.') }
        format.xml  { render :xml => @az_bill, :status => :created, :location => @az_bill }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @az_bill.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /az_bills/1
  # PUT /az_bills/1.xml
  def update
    @az_bill = AzBill.find(params[:id])

    respond_to do |format|
      if @az_bill.update_attributes(params[:az_bill])
        format.html { redirect_to(@az_bill, :notice => 'AzBill was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @az_bill.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /az_bills/1
  # DELETE /az_bills/1.xml
  def destroy
    @az_bill = AzBill.find(params[:id])
    @az_bill.destroy

    respond_to do |format|
      format.html { redirect_to(az_bills_url) }
      format.xml  { head :ok }
    end
  end
end
