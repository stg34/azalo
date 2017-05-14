# Settings specified here will take precedence over those in config/environment.rb

# In the development environment your application's code is reloaded on
# every request.  This slows down response time but is perfect for development
# since you don't have to restart the webserver when you make code changes.
config.cache_classes = false

# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true

# Show full error reports and disable caching
#config.action_controller.consider_all_requests_local = false # Это чтоб в дев режиме отображались страницы 404, 500 и т.д.
config.action_controller.consider_all_requests_local = true


config.action_view.debug_rjs                         = true
config.action_controller.perform_caching             = false
#config.action_controller.perform_caching             = true
config.cache_store = :file_store, 'tmp/cache'

# Don't care if the mailer can't send
config.action_mailer.raise_delivery_errors = true

#config.action_mailer.delivery_method = :sendmail

config.action_mailer.delivery_method = :smtp
config.action_mailer.smtp_settings = {
  :tls => true,
  :address => "smtp.gmail.com",
  :port => 587,
  :enable_starttls_auto => true,
  :domain => "azalo.net",
  :authentication => :plain,
  :user_name => "noreply@azalo.net",
  :password => "e60Z~hECqr"
}


#Time::DATE_FORMATS[:default] = '%Y-%m-%d %H:%M:%S'
Time::DATE_FORMATS[:default] = '%Y.%b.%d %H:%M:%S'

APP_ENVIRONMENT = :development

AZ_PROTOCOL = "http"
AZ_BASE_TASKS_URL = "#{AZ_PROTOCOL}://localhost:3001/"
AZ_TASKS_URL = "#{AZ_BASE_TASKS_URL}issues/"
AZ_URL = "#{AZ_PROTOCOL}://localhost:3000/"

AZ_EMAIL_FOR_MESSAGES = 'stg34@ua.fm'

USE_GOOGLE_ANALYTICS = false

AZ_TEST_PERIOD = 300
AZ_WARNING_PERIOD = 600

ActionController::Base.session = {
  :key         => '_redmine_session',
  :secret      => '5fe95950a30c06c3508fb131aaf8de0edcf36fca9310f1e2bda616045e4cf00d094c8d46aeea7b36'
}


