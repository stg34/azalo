class AzUsersController < ApplicationController

  filter_access_to :all, :attribute_check => true
  #filter_access_to :edit
  
  layout "main"

  # See ConferenceController for comments on the most common use of
  # filter_access_to
  
  #TODO

  #before_filter :confirm_registration, :expect => [:confirm_registration]

  filter_access_to :all
  #filter_access_to :edit, :update, :attribute_check => true
  #filter_access_to :confirm_registration, :require => :update

  # render new.rhtml
  def new
    @hide_hash = true
    @az_user = AzUser.new
    @tariff_id = params[:tariff]
  end

  def new_employee
    @az_user = AzUser.new
    invitation = AzInvitation.find(:first, :conditions => {:hash_str => params[:hash_str].strip})
    ret = true
    #puts "====================================================================="
    #puts invitation.invitation_type
    if invitation == nil || invitation.invitation_type != 'company'
      ret = false
    else
      @az_user.email = invitation.email
      @az_user.hash_str = invitation.hash_str
    end

    @hide_email = true
    @hide_hash = true

    respond_to do |format|
      if ret
        format.html { render :template => 'az_users/new'}
      else
        format.html { render :text => 'incorrect invitation'}
      end
    end

  end


  def create
    logout_keeping_session!

    success = false

    subscribtion_categories = AzSubscribtionCategory.find(:all)

    AzUser.transaction do

      @hide_hash = true
      @az_user = AzUser.new(params[:az_user])
      @az_user.disabled = true
      @az_user.la_accepted = true
      @az_user.roles = [:user]
      @az_user.hash_str = params[:az_user][:hash_str].strip
      @az_user.az_subscribtion_categories.clear
      @az_user.az_subscribtion_categories = subscribtion_categories

      res = @az_user.save
      puts @az_user.errors.inspect

      success = @az_user && res
      puts success
      puts @az_user.errors.empty?
      puts success && @az_user.errors.empty?

      if success && @az_user.errors.empty?

        invitation = AzInvitation.find(:first, :conditions => {:hash_str => @az_user.hash_str})

        if invitation == nil
          invitation = AzInvitation.new
          invitation.invitation_type = 'site'
        end

        if invitation.invitation_type == 'company'
          cmp = AzCompany.find(invitation.invitation_data)
          cmp.add_employee(@az_user)
        elsif invitation.invitation_type == 'site'

          tariff_id = Integer(params[:tariff_id])

          if !AzTariff.get_user_available_tariffs.collect{|t| t.id}.include?(tariff_id)
            tariff = AzTariff.get_free_tariff
          else
            tariff = AzTariff.find(tariff_id)
          end

          company = AzCompany.register_company(@az_user, tariff)
          company.save!

#          ################
#          #precopied_company = AzCompany.get_company_wo_ceo
#          precopied_company = nil
#
#          if precopied_company == nil
#            company = AzCompany.register_company(@az_user, tariff)
#          else
#            company = precopied_company
#            company.created_at = Time.now
#          end
#
#          test_period = AzTestPeriod.new
#          if tariff.price > 0
#            test_period.ends_at = Time.now + AZ_TEST_PERIOD
#          else
#            test_period.ends_at = Time.now
#          end
#
#          company.ceo_id = @az_user.id
#          company.name = 'Студия имени ' + @az_user.login
#          company.az_tariff = tariff
#          company.az_test_period = test_period
#          company.save
#          company.add_employee(@az_user)
#          #############
#          #AzCompany.create(@az_user, tariff)
#          ################
        end

        invitation.user_id = @az_user.id
        invitation.rejected = false
        invitation.save
      end

    end

    

    if success && @az_user.errors.empty?
      # Protects against session fixation attacks, causes request forgery
      # protection if visitor resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset session

      register_confirmation = AzRegisterConfirmation.new(:az_user => @az_user)

      register_confirmation.save!

      RegisterConfirmationMailer.deliver_confirm_registration(register_confirmation.az_user.email, register_confirmation.confirm_hash, @default_url_options[:host])

      redirect_to(:controller => 'az_users', :action => 'registered')
    else
      @hide_hash = true
      @tariff_id = params[:tariff_id]
      #flash[:error]  = "We couldn't set up that account, sorry.  Please try again, or contact an admin (link is above)."
      render :template => 'az_users/new'
      
    end
  end

  def registered
    
  end
  
  def confirmed
    respond_to do |format|
      format.html { render :template => 'az_users/confirmed', :layout => nil}
    end
  end

  def not_confirmed

  end

  def confirm_registration

    confirm_hash = params[:hash_str]
    register_confirmation = AzRegisterConfirmation.find_by_confirm_hash(confirm_hash)
    puts "register_confirmation = " + register_confirmation.to_s
    if register_confirmation != nil
      @az_user = register_confirmation.az_user
      @az_user.disabled = false
      ret = @az_user.save

      puts "---------------------------- confirm_registration!!! --------------------------"

      if ret
        register_confirmation.destroy
      else
        puts "FAILED confirm_registration!!! --------------------------"
      end

      if !ret
        respond_to do |format|
          format.html { render :controller => 'az_users', :action => 'not_confirmed'}
        end
      else
        self.current_user = @az_user
        #redirect_to('/')
        redirect_to(:controller => 'az_users', :action => 'confirmed')
      end
    else
      #puts "register_confirmation == nil"
      respond_to do |format|
        format.html { render :controller => 'az_users', :action => 'not_confirmed'}
      end
    end
    
  end

  def index
    @az_users = AzUser.paginate(:all, :page => params[:page], :order => 'id desc')

    #puts "====================================================================="
    #puts current_user.az_contacts.inspect
    #puts "====================================================================="

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @az_users }
    end
  end

  def users_projects_pages
    @az_users = AzUser.find(:all)

    #puts "====================================================================="
    #puts current_user.az_contacts.inspect
    #puts "====================================================================="

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @az_users }
    end
  end



  def edit

    #puts "====================================================================="
    #puts current_user.inspect
    #puts "====================================================================="
    @az_user = AzUser.find(params[:id])
    respond_to do |format|
      # TODO вынести в authorization_rules
      if current_user.login == 'admin'
        #puts " Admin  ====================================================================="
        format.html # index.html.erb
        #format.xml  { render :xml => @az_users }
      else
        #puts " User  ====================================================================="
        format.html {redirect_to("/")}
      end
    end
  end

  def update
    @az_user = AzUser.find(params[:id])

    #ret = @az_user.update_attributes(params[:az_user])

    if current_user.roles.include?(:admin)
      @az_user.roles = params[:az_user][:roles].map {|r| r.to_sym}
      @az_user.note = params[:az_user][:note]
    end

    respond_to do |format|

      if @az_user.save
        #@az_user.roles = (params[:az_user][:roles] || []).map {|r| r.to_sym}
        #@az_user.roles = ([:admin] || []).map {|r| r.to_sym}
        
        # TODO
        flash[:notice] = @az_user.login + ' was successfully updated.'
        format.html { render :action => "edit" }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @az_user.errors, :status => :unprocessable_entity }
      end
    end
  end

  def change_password
    respond_to do |format|
      format.html { render :template => 'az_users/change_password', :locals => {:user => current_user } }
    end
  end

  def recover_password
    @az_user = AzUser.new
    respond_to do |format|
      format.html { render :template => 'az_users/recover_password'}
    end
  end

  def reset_password
    @az_user = AzUser.new
    params_login = params[:az_user][:login]
    params_email = params[:az_user][:email]

    @az_user.login = params_login
    @az_user.email = params_email
    usr_l = nil
    usr_e = nil
    usr = nil
    if (params_login != '')
      usr_l = AzUser.find_by_login(params_login)
      usr = usr_l
    end
    
    if (params_email != '')
      usr_e = AzUser.find_by_email(params_email)
      usr = usr_e
    end

    error = nil

    if params_login == '' && params_email == ''
      error = 'no_params'
      @az_user.errors.add_to_base("Не указан логин или электронная почта")
    elsif params_login != '' && params_email != '' && (usr_e == nil || usr_l == nil)
      error = 'login_doesnt_match_email'
      @az_user.errors.add_to_base("Логин и почта не соответсвуют друг другу")
    elsif usr_e == nil && usr_l == nil
      error = 'no_such_user'
      @az_user.errors.add_to_base("Пользователь не найден")
    elsif usr_e != nil && usr_l != nil && usr_e.id != usr_l.id
      error = 'login_doesnt_match_email'
      @az_user.errors.add_to_base("Логин и почта не соответсвуют друг другу")
    end

    if error == nil
      reset = AzResetPassword.new
      reset.az_user = usr
      reset.save!
      PasswordMailer.deliver_reset_password_hash(usr.login, usr.name, usr.email, reset.hash_str, @default_url_options[:host])
    end

    
    respond_to do |format|
      if error == nil
        format.html { render :template => 'az_users/recover_password_result'}
      else
        format.html { render :template => 'az_users/recover_password'}
      end
    end
  end

  def new_password
    reset = AzResetPassword.find_by_hash_str(params[:hash_str])
    error = nil
    if reset == nil
      error = :no_such_hash
    else
      user = reset.az_user
    end
    respond_to do |format|
      if error
        format.html { render :text => 'Not found'}
      else
        format.html { render :template => 'az_users/new_password', :locals => {:user => user, :hash_str => reset.hash_str }}
      end
    end
  end

  def license_agreement
    respond_to do |format|
      format.html { render :layout => false, :template => 'az_users/license_agreement'}
    end
  end

  def accept_la
    if params[:choise] != nil
      if Integer(params[:choise]) == 42
        current_user.la_accepted = true
        current_user.save
      else
        current_user.la_accepted = false
        current_user.save
        logout_killing_session!
      end
      respond_to do |format|
        format.html { redirect_to('/') }
      end
    else
      respond_to do |format|
        format.html { render :layout => false, :template => 'az_users/accept_la'}
      end
    end
  end

  def set_new_password

    reset = AzResetPassword.find_by_hash_str(params[:hash_str])

    new_password = params[:az_user][:new_password]
    new_password_confirmation = params[:az_user][:new_password_confirmation]

    user = reset.az_user

    user.password = new_password
    user.password_confirmation = new_password_confirmation

    respond_to do |format|
      if user.save
        reset.destroy
        flash[:notice] = 'Пароль успешно изменен.'
        format.html { redirect_to('/login') }
      else
        user.new_password = ''
        user.new_password_confirmation = ''
        format.html { render :template => 'az_users/new_password', :locals => {:user => user, :hash_str => reset.hash_str }}
      end
    end

  end

  def password_sent
    respond_to do |format|
      format.html { render :template => 'az_users/recover_password_result'}
    end
  end

  def password_not_sent
    respond_to do |format|
      format.html { render :template => 'az_users/recover_password_result'}
    end
  end

  def update_password

    current_user.old_password = params[:az_user][:old_password]
    current_user.new_password = params[:az_user][:new_password]
    current_user.new_password_confirmation = params[:az_user][:new_password_confirmation]

    puts params[:az_user].inspect

    current_user.password = current_user.new_password
    current_user.password_confirmation = current_user.new_password  # TODO WTF?

    respond_to do |format|
      if current_user.save
        flash[:notice] = 'Пароль успешно изменен.'
        format.html { redirect_to('/profile') }
      else
        current_user.old_password = ''
        current_user.new_password = ''
        current_user.new_password_confirmation = ''
        format.html { render :template => 'az_users/change_password', :locals => {:user => current_user } }
      end
    end
  end

  def change_subscribtion

    if params[:az_user]
      puts "params[:az_user] -------------------------------------------"
      #subscribtion_category_ids = current_user.az_subscribtion_categories.collect{|sc| sc.id}
      if params[:az_user][:az_subscribtion_categories_ids]
        subscribtion_categories = AzSubscribtionCategory.find(params[:az_user][:az_subscribtion_categories_ids])
      else
        subscribtion_categories = []
      end
      current_user.az_subscribtion_categories.clear
      current_user.az_subscribtion_categories = subscribtion_categories
      current_user.save
    end
    puts '00000000000000000000000000000000000000000000000000000000'

    @subscribtion_categories = AzSubscribtionCategory.find(:all)
    @user = current_user
  end

  def unsubscribe
    if current_user.class == AzUser
      respond_to do |format|
          format.html { redirect_to(:action => 'change_subscribtion') }
      end
      return
    end

    @crypted_id = params[:id]
    user_id = Blowfish.decrypt("1234567812345678", Base64.decode64(@crypted_id))
    prefix = 'u_'
    if user_id[0..(prefix.length-1)] != prefix
      respond_to do |format|
        format.html { render(:text => 'Error') }
      end
      return
    end
    id = user_id[prefix.length..-1]
    @subscribtion_categories = AzSubscribtionCategory.find(:all)
    @user = AzUser.find(id)
        
    if params[:az_user]
      puts "params[:az_user] -------------------------------------------"
      #subscribtion_category_ids = current_user.az_subscribtion_categories.collect{|sc| sc.id}
      if params[:az_user][:az_subscribtion_categories_ids]
        subscribtion_categories = AzSubscribtionCategory.find(params[:az_user][:az_subscribtion_categories_ids])
      else
        subscribtion_categories = []
      end
      @user.az_subscribtion_categories.clear
      @user.az_subscribtion_categories = subscribtion_categories
      @user.save(false)
    end

  end

  #def permission_denied
  #  flash[:error] = "Sorry, you are not allowed to access that page."
  #  redirect_to '/login'
  #end

  def hide_warning_message
    
    if session[:hide_warnings] == nil
      session[:hide_warnings] = {}
    end
    
    session[:hide_warnings][Integer(params[:id])] = true
    
    respond_to do |format|
      format.html { render :text => ''}
    end
  end

end
