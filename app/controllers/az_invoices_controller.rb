class AzInvoicesController < ApplicationController
  # GET /az_invoices
  # GET /az_invoices.xml
  def index
    @az_invoices = AzInvoice.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @az_invoices }
    end
  end

  # GET /az_invoices/1
  # GET /az_invoices/1.xml
  def show
    @az_invoice = AzInvoice.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @az_invoice }
    end
  end

  # GET /az_invoices/new
  # GET /az_invoices/new.xml
  def new
    @az_invoice = AzInvoice.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @az_invoice }
    end
  end

  # GET /az_invoices/1/edit
  def edit
    @az_invoice = AzInvoice.find(params[:id])
  end

  # POST /az_invoices
  # POST /az_invoices.xml
  def create
    @az_invoice = AzInvoice.new(params[:az_invoice])

    respond_to do |format|
      if @az_invoice.save
        format.html { redirect_to(@az_invoice, :notice => 'AzInvoice was successfully created.') }
        format.xml  { render :xml => @az_invoice, :status => :created, :location => @az_invoice }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @az_invoice.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /az_invoices/1
  # PUT /az_invoices/1.xml
  def update
    @az_invoice = AzInvoice.find(params[:id])

    respond_to do |format|
      if @az_invoice.update_attributes(params[:az_invoice])
        format.html { redirect_to(@az_invoice, :notice => 'AzInvoice was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @az_invoice.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /az_invoices/1
  # DELETE /az_invoices/1.xml
  def destroy
    @az_invoice = AzInvoice.find(params[:id])
    @az_invoice.destroy

    respond_to do |format|
      format.html { redirect_to(az_invoices_url) }
      format.xml  { head :ok }
    end
  end
end
