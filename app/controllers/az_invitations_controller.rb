class AzInvitationsController < ApplicationController

  filter_access_to :invite_to_site, :create_invitation_to_site, :invite_to_company, :create_invitation_to_company
  filter_access_to :all, :attribute_check => true
  

  layout "main"
  
  # GET /az_invitations/1
  # GET /az_invitations/1.xml
  def show
    @az_invitation = AzInvitation.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @az_invitation }
    end
  end

  def invite_to_site
    @az_invitation = AzInvitation.new
    @az_invitation.invitation_type = 'site'
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @az_invitation }
    end
  end


  def invite_to_company
    @az_invitation = AzInvitation.new
    #@az_invitation.invitation_type = 'company'
    @az_invitation.invitation_data = params[:owner_id]

    if current_user.az_companies.collect{|c| c.id}.include?(Integer(params[:owner_id]))
      @cmp = AzCompany.find(@az_invitation.invitation_data)
      res = true
    else
      res = false
    end

    respond_to do |format|
      if res
        format.html # new.html.erb
        format.xml  { render :xml => @az_invitation }
      else
        format.html # new.html.erb
        #format.html { render :text => 'Error' }
      end
    end
  end

  # POST /az_invitations
  # POST /az_invitations.xml
  def create_invitation_to_site
    @az_invitation = AzInvitation.new(params[:az_invitation])

    puts params[:az_invitation].inspect
    if params[:az_invitation][:invitation_type] == 'site'
      @az_invitation.invitation_type = 'site'
    end
    @az_invitation.invitation_data = current_user.id

    

    respond_to do |format|
      if @az_invitation.save

        user_name = current_user.name + " " + current_user.lastname
        InvitationMailer.deliver_invitation_to_site(@az_invitation.email, @az_invitation.hash_str, user_name, @default_url_options[:host])

        flash[:notice] = 'Приглашение на сайт успешно создано.'
        format.html { redirect_to('/profile') }
        format.xml  { render :xml => @az_invitation, :status => :created, :location => @az_invitation }
      else
        format.html { render :action => "invite_to_site" }
        format.xml  { render :xml => @az_invitation.errors, :status => :unprocessable_entity }
      end
    end
  end


  def resend_invitation_to_site
    @az_invitation = AzInvitation.find(params[:id])

    respond_to do |format|
        user_name = current_user.name + " " + current_user.lastname
        InvitationMailer.deliver_invitation_to_site(@az_invitation.email, @az_invitation.hash_str, user_name, @default_url_options[:host])
        flash[:notice] = 'Приглашение на сайт успешно отправлено.'
        format.html { redirect_to('/profile') }
        format.xml  { render :xml => @az_invitation, :status => :created, :location => @az_invitation }
    end
  end


  def create_invitation_to_company
    @az_invitation = AzInvitation.new(params[:az_invitation])

    #puts "================================================================="
    #puts params
    #puts params[:az_invitation].inspect
    #puts "================================================================="
    
    @az_invitation.invitation_type = 'company'

    # TODO проверить params[:az_invitation][:owner_id] - я имею отношение к этим фирмам?
    #if current_user.az_companies.collect{|c| c.id}.include?(Integer(params[:az_invitation][:invitation_data]))

    @az_invitation.invitation_data = params[:az_invitation][:invitation_data]
    @cmp = AzCompany.find(@az_invitation.invitation_data)
    if @cmp.ceo_id == current_user.id
      res = @az_invitation.save
    else 
      res = false
      @cmp = nil
    end

    invitee_user = AzUser.find(:first, :conditions => {:email => @az_invitation.email})

    respond_to do |format|
      if res
        user_name = current_user.name + " " + current_user.lastname
        company_name = @cmp.name
        if invitee_user == nil
          InvitationMailer.deliver_invitation_to_company(@az_invitation.email, @az_invitation.hash_str, company_name, user_name, @default_url_options[:host])
        else
          InvitationMailer.deliver_invitation_to_company_existing_user(@az_invitation.email, @az_invitation.hash_str, company_name, user_name, @default_url_options[:host])
        end

        flash[:notice] = 'Приглашение в студию успешно создано.'
        format.html { redirect_to('/profile') }
        format.xml  { render :xml => @az_invitation, :status => :created, :location => @az_invitation }
      else
        if @cmp == nil
          format.html { render :text => "Error" }
        else
          format.html { render :action => "invite_to_company" }
          format.xml  { render :xml => @az_invitation.errors, :status => :unprocessable_entity }
        end
        
      end
    end
  end

#  def create
#    @az_invitation = AzInvitation.new(params[:az_invitation])
#
#    respond_to do |format|
#      if @az_invitation.save
#        flash[:notice] = 'AzInvitation was successfully created.'
#        format.html { redirect_to(@az_invitation) }
#        format.xml  { render :xml => @az_invitation, :status => :created, :location => @az_invitation }
#      else
#        format.html { render :action => "new" }
#        format.xml  { render :xml => @az_invitation.errors, :status => :unprocessable_entity }
#      end
#    end
#  end

  # DELETE /az_invitations/1
  # DELETE /az_invitations/1.xml
#  def destroy
#    @az_invitation = AzInvitation.find(params[:id])
#    @az_invitation.destroy
#
#    respond_to do |format|
#      format.html { redirect_to(az_invitations_url) }
#      format.xml  { head :ok }
#    end
#  end
  
  def delete_invitation
    @az_invitation = AzInvitation.find(params[:id])
    if @az_invitation.rejected == nil || @az_invitation.rejected == true
      @az_invitation.destroy
    end

    respond_to do |format|
      format.html { redirect_to(:controller => 'az_profiles', :action => 'index') }
      format.xml  { head :ok }
    end
  end

  def accept
    @az_invitation = AzInvitation.find(params[:id])
    if @az_invitation.invitation_type == 'company'
      cmp = AzCompany.find(@az_invitation.invitation_data)
      user = AzUser.find(@az_invitation.user_id)
      cmp.add_employee(user)
      @az_invitation.hash_str = ''
      @az_invitation.rejected = false
      @az_invitation.save
      #@az_invitation.destroy
    end

    respond_to do |format|
      format.html { redirect_to(:controller => 'az_profiles', :action => 'index') }
      format.xml  { head :ok }
    end
  end


  def reject
    @az_invitation = AzInvitation.find(params[:id])
    @az_invitation.rejected = true
    @az_invitation.save

    respond_to do |format|
      format.html { redirect_to(:controller => 'az_profiles', :action => 'index') }
      format.xml  { head :ok }
    end
  end

end
