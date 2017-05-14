class AzBalanceTransactionsController < ApplicationController

  filter_access_to:index
  filter_access_to :all, :attribute_check => true

  layout "main"

  # GET /az_balance_transactions
  # GET /az_balance_transactions.xml
  def index
    conditions = {}
    if params[:login]
      user = AzUser.find_by_login(params[:login])
      company = AzCompany.find(:first, :conditions => {:ceo_id => user.id}) if user 
      conditions.merge!({:az_company_id => company.id}) if company
    end

    @az_balance_transactions = AzBalanceTransaction.paginate(:page => params[:page], :order => 'created_at desc', :conditions => conditions)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @az_balance_transactions }
    end
  end

  # GET /az_balance_transactions/1
  # GET /az_balance_transactions/1.xml
  def show
    @az_balance_transaction = AzBalanceTransaction.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @az_balance_transaction }
    end
  end

  # GET /az_balance_transactions/new
  # GET /az_balance_transactions/new.xml
  def new
    @az_balance_transaction = AzBalanceTransaction.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @az_balance_transaction }
    end
  end

  # GET /az_balance_transactions/1/edit
  def edit
    @az_balance_transaction = AzBalanceTransaction.find(params[:id])
  end

  # POST /az_balance_transactions
  # POST /az_balance_transactions.xml
  def create
    @az_balance_transaction = AzBalanceTransaction.new(params[:az_balance_transaction])

    respond_to do |format|
      if @az_balance_transaction.save
        format.html { redirect_to(@az_balance_transaction, :notice => 'AzBalanceTransaction was successfully created.') }
        format.xml  { render :xml => @az_balance_transaction, :status => :created, :location => @az_balance_transaction }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @az_balance_transaction.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /az_balance_transactions/1
  # PUT /az_balance_transactions/1.xml
  def update
    @az_balance_transaction = AzBalanceTransaction.find(params[:id])

    respond_to do |format|
      if @az_balance_transaction.update_attributes(params[:az_balance_transaction])
        format.html { redirect_to(@az_balance_transaction, :notice => 'AzBalanceTransaction was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @az_balance_transaction.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /az_balance_transactions/1
  # DELETE /az_balance_transactions/1.xml
  def destroy
    @az_balance_transaction = AzBalanceTransaction.find(params[:id])
    @az_balance_transaction.destroy

    respond_to do |format|
      format.html { redirect_to(az_balance_transactions_url) }
      format.xml  { head :ok }
    end
  end
end
