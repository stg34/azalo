class AzRegisterConfirmationsController < ApplicationController

  filter_access_to :all

  # GET /az_register_confirmations
  # GET /az_register_confirmations.xml
  def index
    @az_register_confirmations = AzRegisterConfirmation.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @az_register_confirmations }
    end
  end

  # GET /az_register_confirmations/1
  # GET /az_register_confirmations/1.xml
  def show
    @az_register_confirmation = AzRegisterConfirmation.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @az_register_confirmation }
    end
  end

  # GET /az_register_confirmations/new
  # GET /az_register_confirmations/new.xml
  def new
    @az_register_confirmation = AzRegisterConfirmation.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @az_register_confirmation }
    end
  end

  # GET /az_register_confirmations/1/edit
  def edit
    @az_register_confirmation = AzRegisterConfirmation.find(params[:id])
  end

  # POST /az_register_confirmations
  # POST /az_register_confirmations.xml
  def create
    @az_register_confirmation = AzRegisterConfirmation.new(params[:az_register_confirmation])

    respond_to do |format|
      if @az_register_confirmation.save
        flash[:notice] = 'AzRegisterConfirmation was successfully created.'
        format.html { redirect_to(@az_register_confirmation) }
        format.xml  { render :xml => @az_register_confirmation, :status => :created, :location => @az_register_confirmation }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @az_register_confirmation.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /az_register_confirmations/1
  # PUT /az_register_confirmations/1.xml
  def update
    @az_register_confirmation = AzRegisterConfirmation.find(params[:id])

    respond_to do |format|
      if @az_register_confirmation.update_attributes(params[:az_register_confirmation])
        flash[:notice] = 'AzRegisterConfirmation was successfully updated.'
        format.html { redirect_to(@az_register_confirmation) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @az_register_confirmation.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /az_register_confirmations/1
  # DELETE /az_register_confirmations/1.xml
  def destroy
    @az_register_confirmation = AzRegisterConfirmation.find(params[:id])
    @az_register_confirmation.destroy

    respond_to do |format|
      format.html { redirect_to(az_register_confirmations_url) }
      format.xml  { head :ok }
    end
  end

  def resend
    register_confirmation = AzRegisterConfirmation.find(params[:id])
    ret = "ERROR"
    if register_confirmation
      RegisterConfirmationMailer.deliver_confirm_registration(register_confirmation.az_user.email, register_confirmation.confirm_hash, @default_url_options[:host])
      ret = "OK"
    end

    respond_to do |format|
      format.html { render(:text => ret) }
      format.xml  { head :ok }
    end
  end
end
