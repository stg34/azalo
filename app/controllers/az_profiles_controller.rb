class AzProfilesController < ApplicationController

  filter_access_to :all

  layout "main"

  # GET /az_profiles
  # GET /az_profiles.xml
  def index    
    @az_contacts = current_user.az_contacts
    @me = current_user
    @my_invitations_to_site = current_user.get_my_invitations_to_site
    @my_invited_users = current_user.get_my_invited_users

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @az_profiles }
    end
  end

  # GET /az_profiles/1
  # GET /az_profiles/1.xml
#  def show
#    @az_profile = AzProfile.find(params[:id])
#
#    respond_to do |format|
#      format.html # show.html.erb
#      format.xml  { render :xml => @az_profile }
#    end
#  end
#
#  # GET /az_profiles/new
#  # GET /az_profiles/new.xml
#  def new
#    @az_profile = AzProfile.new
#
#    respond_to do |format|
#      format.html # new.html.erb
#      format.xml  { render :xml => @az_profile }
#    end
#  end
#
#  # GET /az_profiles/1/edit
#  def edit
#    @az_profile = AzProfile.find(params[:id])
#  end
#
#  # POST /az_profiles
#  # POST /az_profiles.xml
#  def create
#    @az_profile = AzProfile.new(params[:az_profile])
#
#    respond_to do |format|
#      if @az_profile.save
#        flash[:notice] = 'AzProfile was successfully created.'
#        format.html { redirect_to(@az_profile) }
#        format.xml  { render :xml => @az_profile, :status => :created, :location => @az_profile }
#      else
#        format.html { render :action => "new" }
#        format.xml  { render :xml => @az_profile.errors, :status => :unprocessable_entity }
#      end
#    end
#  end
#
#  # PUT /az_profiles/1
#  # PUT /az_profiles/1.xml
#  def update
#    @az_profile = AzProfile.find(params[:id])
#
#    respond_to do |format|
#      if @az_profile.update_attributes(params[:az_profile])
#        flash[:notice] = 'AzProfile was successfully updated.'
#        format.html { redirect_to(@az_profile) }
#        format.xml  { head :ok }
#      else
#        format.html { render :action => "edit" }
#        format.xml  { render :xml => @az_profile.errors, :status => :unprocessable_entity }
#      end
#    end
#  end
#
#  # DELETE /az_profiles/1
#  # DELETE /az_profiles/1.xml
#  def destroy
#    @az_profile = AzProfile.find(params[:id])
#    @az_profile.destroy
#
#    respond_to do |format|
#      format.html { redirect_to(az_profiles_url) }
#      format.xml  { head :ok }
#    end
#  end
end
