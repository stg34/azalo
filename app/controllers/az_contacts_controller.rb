class AzContactsController < ApplicationController

  filter_access_to :all

  layout "main"

  # GET /contacts
  # GET /contacts.xml
  def index
    @az_contacts = AzContact.all
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @az_contacts }
    end
  end


  # GET /contacts
  # GET /contacts.xml
  def index_user
    @az_contacts = current_user.az_contacts
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @az_contacts }
    end
  end

  # GET /contacts/1
  # GET /contacts/1.xml
  def show
    @az_contact = AzContact.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @az_contact }
    end
  end

  # GET /contacts/new
  # GET /contacts/new.xml
  def new
    @az_contact = AzContact.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @az_contact }
    end
  end

  # GET /contacts/1/edit
  def edit
    @az_contact = AzContact.find(params[:id])
  end

  # POST /contacts
  # POST /contacts.xml
  def create
    @az_contact = current_user.add_contact_by_login(params[:az_contact][:login])
    respond_to do |format|
      if @az_contact != nil
        if @az_contact.save
          flash[:notice] = 'Contact was successfully created.'
          format.html { redirect_to(:action => 'index_user') }
          format.xml  { render :xml => @az_contact, :status => :created, :location => @az_contact }
        else
          format.html { render :action => "new" }
          format.xml  { render :xml => @az_contact.errors, :status => :unprocessable_entity }
        end
      else
        flash[:notice] = 'Нет такого пользователя.'
        @az_contact = AzContact.new
        format.html { render :action => "new" }
        format.xml  { render :xml => @az_contact.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /contacts/1
  # PUT /contacts/1.xml
  def update
    @az_contact = AzContact.find(params[:id])

    respond_to do |format|
      if @az_contact.update_attributes(params[:az_contact])
        flash[:notice] = 'Contact was successfully updated.'
        format.html { redirect_to(@az_contact) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @az_contact.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /contacts/1
  # DELETE /contacts/1.xml
  def destroy
    @az_contact = AzContact.find(params[:id])
    @az_contact.destroy

    respond_to do |format|
      format.html { redirect_to(:action => 'index_user') }
      format.xml  { head :ok }
    end
  end
end
