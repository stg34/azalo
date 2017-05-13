class AzPurchasesController < ApplicationController

  filter_access_to :all

  layout "main"

  # GET /az_purchases
  # GET /az_purchases.xml
  def index
    @az_purchases = AzPurchase.paginate(:page => params[:page], :order => 'created_at desc')

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @az_purchases }
    end
  end

  # GET /az_purchases/1
  # GET /az_purchases/1.xml
  def show
    @az_purchase = AzPurchase.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @az_purchase }
    end
  end

  # GET /az_purchases/new
  # GET /az_purchases/new.xml
#  def new
#    @az_purchase = AzPurchase.new
#
#    respond_to do |format|
#      format.html # new.html.erb
#      format.xml  { render :xml => @az_purchase }
#    end
#  end

  # GET /az_purchases/1/edit
#  def edit
#    @az_purchase = AzPurchase.find(params[:id])
#  end
#
#  # POST /az_purchases
#  # POST /az_purchases.xml
#  def create
#    @az_purchase = AzPurchase.new(params[:az_purchase])
#
#    respond_to do |format|
#      if @az_purchase.save
#        format.html { redirect_to(@az_purchase, :notice => 'AzPurchase was successfully created.') }
#        format.xml  { render :xml => @az_purchase, :status => :created, :location => @az_purchase }
#      else
#        format.html { render :action => "new" }
#        format.xml  { render :xml => @az_purchase.errors, :status => :unprocessable_entity }
#      end
#    end
#  end
#
#  # PUT /az_purchases/1
#  # PUT /az_purchases/1.xml
#  def update
#    @az_purchase = AzPurchase.find(params[:id])
#
#    respond_to do |format|
#      if @az_purchase.update_attributes(params[:az_purchase])
#        format.html { redirect_to(@az_purchase, :notice => 'AzPurchase was successfully updated.') }
#        format.xml  { head :ok }
#      else
#        format.html { render :action => "edit" }
#        format.xml  { render :xml => @az_purchase.errors, :status => :unprocessable_entity }
#      end
#    end
#  end

  # DELETE /az_purchases/1
  # DELETE /az_purchases/1.xml
  def destroy
    @az_purchase = AzPurchase.find(params[:id])
    @az_purchase.destroy

    respond_to do |format|
      format.html { redirect_to(az_purchases_url) }
      format.xml  { head :ok }
    end
  end
end
