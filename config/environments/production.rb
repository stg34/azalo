# Settings specified here will take precedence over those in config/environment.rb

# The production environment is meant for finished, "live" apps.
# Code is not reloaded between requests
config.cache_classes = true

# Full error reports are disabled and caching is turned on
config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching             = true
config.action_view.cache_template_loading            = true

# See everything in the log (default is :info)
# config.log_level = :debug

# Use a different logger for distributed setups
# config.logger = SyslogLogger.new

# Use a different cache store in production
# config.cache_store = :mem_cache_store
config.cache_store = :file_store, 'tmp/cache'

# Enable serving of images, stylesheets, and javascripts from an asset server
# config.action_controller.asset_host = "http://assets.example.com"

# Disable delivery errors, bad email addresses will be ignored
# config.action_mailer.raise_delivery_errors = false

# Enable threaded mode
# config.threadsafe!

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

Time::DATE_FORMATS[:default] = '%Y-%m-%d %H:%M:%S'

APP_ENVIRONMENT = :production

AZ_PROTOCOL = "https"
AZ_BASE_TASKS_URL = "#{AZ_PROTOCOL}://tasks.azalo.net/"
AZ_TASKS_URL = "#{AZ_BASE_TASKS_URL}issues/"
AZ_URL = "#{AZ_PROTOCOL}://azalo.net/"

AZ_EMAIL_FOR_MESSAGES = 'support@azalo.net, stg34@ua.fm'

USE_GOOGLE_ANALYTICS = true

AZ_TEST_PERIOD = 3600*24*7
AZ_WARNING_PERIOD = 3600*24*7

ActionController::Base.session = {
  :key         => '_redmine_session',
  :secret      => '5fe95950a30c06c3508fb131aaf8de0edcf36fca9310f1e2bda616045e4cf00d094c8d46aeea7b36',
  :domain => ".azalo.net"
}