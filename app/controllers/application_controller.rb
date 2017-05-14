# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base

    def putsd(*args)
      print "#{Pathname.new(__FILE__).basename}-#{__LINE__}  "
      puts(args)
    end

    ############################################################
    # ERROR HANDLING et Foo
    include ExceptionNotification::ExceptionNotifiable
    #Comment out the line below if you want to see the normal rails errors in normal development.
    #alias :rescue_action_locally :rescue_action_in_public if Rails.env == 'development'
    #self.exception_notifiable_noisy_environments = ["production", 'development']
    self.exception_notifiable_noisy_environments = ["production"]
    #self.error_layout = 'error'
    self.exception_notifiable_notification_level = [:email]
    self.exception_notifiable_verbose = false #SEN uses logger.info, so won't be verbose in production
    #self.exception_notifiable_pass_through = :hoptoad # requires the standard hoptoad gem to be installed, and setup normally
    #    self.exception_notifiable_silent_exceptions = [Acl9::AccessDenied, MethodDisabled, ActionController::RoutingError ]
    #specific errors can be handled by something else:
    #rescue_from 'Acl9::AccessDenied', :with => :access_denied
    # END ERROR HANDLING
    ############################################################


  @@app_session = nil

  helper :all # include all helpers, all the time
  #protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  filter_parameter_logging :password

  helper_method :current_user, :logged_in?

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '8e49e1c945c636c4e5062b7fa72f2333'

  # See ActionController::Base for details
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password").
  # filter_parameter_logging :password

  include AuthenticatedSystem
  

  hide_action :breadcrumb
  def breadcrumbs
    []
  end

  append_before_filter :set_mailer_url_options
  append_before_filter :accept_la_filter
  append_before_filter :set_locale

  def set_locale
    logger.debug "* Accept-Language: #{request.env['HTTP_ACCEPT_LANGUAGE']}"
    I18n.locale = extract_locale_from_accept_language_header || I18n.default_locale
    I18n.locale = 'ru'
    logger.debug "* Locale set to '#{I18n.locale}'"
  end
 
  def extract_locale_from_accept_language_header
    if request.env['HTTP_ACCEPT_LANGUAGE']
      return request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first
    end
    return 'en'
  end

  def accept_la_filter
    #puts "#{current_user.class} ==================================================================================="
    if current_user && current_user.class == AzUser
      #puts "#{current_user.class} ==================================================================================="
      if current_user.la_accepted != nil || !current_user.roles.include?(:user)
        return
      end
        
      skip = params[:action] == 'accept_la' && params[:controller] == 'az_users'
      if !skip
        respond_to do |format|
          format.html { redirect_to :controller => 'az_users', :action => 'accept_la' }
        end
      end
      #puts "==================================================================================="
      #puts params[:controller]
      #puts "==================================================================================="
      
    end
  end

  # for details see http://blog.jennyfong.net/tag/default_url_options/
  def set_mailer_url_options
  
    session[:foo_bar] = nil
  
    #puts "------------------ TODO: use AZ_URL set_mailer_url_options --------------------------"
    #puts request.host_with_port
    #puts "------------------ set_mailer_url_options --------------------------0"
    ActionMailer::Base.default_url_options[:host] = request.host_with_port
    
    if @default_url_options == nil
      @default_url_options = {}
    end
    
    @default_url_options[:host] = request.host_with_port
    #request.host  would return the host without the port number (quite obvious I guess)
  end



  # Start of declaration_authorization-related code
  before_filter :set_current_user

  # One way of using declarative_authorization is to restrict access
  # to controller actions by default by stating the following line.
  # This installs a default before_filter for authorization according
  # to the action names.
  #filter_access_to :all


  def get_title
    if @title == nil
    return 'Azalo'
    else
      return @title
    end
  end

  def self.get_guest_project_ids
    return @@app_session[:guest_project_ids]
  end

  def self.set_guest_project_ids(ids)
    if @@app_session == nil
      @@app_session = {}
    end
     @@app_session[:guest_project_ids] = ids
  end


  protected
  # There are multiple ways of handling authorization failures.
  # One is to implement a permission denied method as shown below.
  # If none is defined, either a simple string is displayed
  # to the user ("You are not allowed...", default) or the authorization
  # exception is raised.  TODO state configuration option
  #
  #def permission_denied
  #  respond_to do |format|
  #    flash[:error] = 'Sorry, you are not allowed to view the requested page.'
  #    format.html { redirect_to(:back) rescue redirect_to('/') }
  #    format.xml  { head :unauthorized }
  #    format.js   { head :unauthorized }
  #  end
  #end

  # set_current_user sets the global current user for this request.  This
  # is used by model security that does not have access to the
  # controller#current_user method.  It is called as a before_filter.
  def set_current_user
    Authorization.current_user = current_user

    logger.info "=================== Authorization.current_user =============================="
    if Authorization.current_user.class == AzUser
      logger.info ">>>>>>>>>> current user: " + Authorization.current_user.login + ", roles: #{Authorization.current_user.role_symbols}, IP: " + request_origin + " <<<<<<<<<<"
    else
      logger.info ">>>>>>>>>> current user: " + 'Guest' + " IP: " + request_origin + " <<<<<<<<<<"
    end

    @@app_session = session

    
    #logger.error session.inspect
    #self.logger.error session.inspect

#    if session[:guest_project_ids] == nil
#      session[:guest_project_ids] = Time.now.to_s
#    end
#    if current_user
#      current_user.guest_project_ids = session[:guest_project_ids]
#      logger.info "=================== set_current_user =============================="
#      logger.info current_user.inspect
#      logger.info current_user.guest_project_ids
#      logger.info "=================== set_current_user =============================="
#    end
    
  end

  def show_type_str_to_sym(show_type_str)

    case show_type_str
      when 'design':
          show_type_sym = :design
      when 'components':
          show_type_sym = :components
      when 'data':
          show_type_sym = :data
      when 'description':
          show_type_sym = :description
      else
        show_type_sym = :design
    end
    return show_type_sym
  end

  def permission_denied
    #flash[:error] = "Sorry, you are not allowed to access that page."
    puts "#{RAILS_ROOT} ================================================================================"
    puts request.inspect
    puts request.xhr?
    if request.xhr?
      render :status => 403, :text => "403"
    else
      #render :file => "public/403.html", :status => 403, :layout => false
      #render :file => "#{RAILS_ROOT}/public/403.html"
      text = IO.read("#{RAILS_ROOT}/public/403.html")
      render :status => 403, :text => text , :content_type => 'text/html' #TODO Чё за фигня? Почему не #render :file => "public/403.html" ???
    end
  end

  def set_project_task_types(project, role_ids)
    if session['project_task_roles'] == nil
      session['project_task_roles'] = {}
    end

    session['project_task_roles'][project.id] = role_ids
    #puts session['project_task_roles'][project.id].inspect
  end

  def get_class(params)
    controller_name = params[:controller]
    commons_class = controller_name.singularize.classify
    return eval(commons_class)
  end

  # def method_missing(m, *args, &block)
  #   Rails.logger.error(m)
  #   #redirect_to :controller=>"errors", :action=>"error_404"
  #   respond_to do |format|
  #     format.html { render :template => 'public/404.html', :layout => false }
  #   end
  #   # or render/redirect_to somewhere else
  # end

  def error_404
    Rails.logger.error(caller)
    respond_to do |format|
      format.html { render :text => '404 not found', :layout => false }
    end
  end

  #def error_500(m, *args, &block)
  def error_500(exc)
    Rails.logger.error(caller)
    respond_to do |format|
      format.html { render :text => '500 internal server error'}
    end
  end

  unless ActionController::Base.consider_all_requests_local
    rescue_from Exception, :with => :error_500
    rescue_from ActiveRecord::RecordNotFound, :with => :error_404
    #rescue_from AbstractController::ActionNotFound, :with => :method_missing
    rescue_from ActionController::RoutingError, :with => :error_404
    rescue_from ActionController::UnknownController, :with => :error_404
    rescue_from ActionController::UnknownAction, :with => :error_404
  end

end

