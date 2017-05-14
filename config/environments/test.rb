# Settings specified here will take precedence over those in config/environment.rb

# The test environment is used exclusively to run your application's
# test suite.  You never need to work with it otherwise.  Remember that
# your test database is "scratch space" for the test suite and is wiped
# and recreated between test runs.  Don't rely on the data there!
config.cache_classes = true

# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true

# Show full error reports and disable caching
config.action_controller.consider_all_requests_local = true
config.action_controller.perform_caching             = false
config.action_view.cache_template_loading            = true

# Disable request forgery protection in test environment
config.action_controller.allow_forgery_protection    = false

# Tell Action Mailer not to deliver emails to the real world.
# The :test delivery method accumulates sent emails in the
# ActionMailer::Base.deliveries array.
config.action_mailer.delivery_method = :test

# Use SQL instead of Active Record's schema dumper when creating the test database.
# This is necessary if your schema can't be completely dumped by the schema dumper,
# like if you have constraints or database-specific column types
# config.active_record.schema_format = :sql

APP_ENVIRONMENT = :test

USE_GOOGLE_ANALYTICS = false

AZ_TEST_PERIOD = 10
AZ_WARNING_PERIOD = 3600

AZ_EMAIL_FOR_MESSAGES = 'stg34@ua.fm'

ActionController::Base.session = {
  :key         => '_redmine_session',
  :secret      => '5fe95950a30c06c3508fb131aaf8de0edcf36fca9310f1e2bda616045e4cf00d094c8d46aeea7b36',
  :domain => ".azalo.net"
}

config.gem "factory_girl", :lib => "factory_girl", :version => '2.6.4'
