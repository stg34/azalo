require 'rubygems'
require 'unicode'
require 'lib/string'
require 'lib/owner_utils'
require 'redcloth'
#require 'russian'

#include

# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
# RAILS_GEM_VERSION = '2.3.2' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  # Specify gems that this application depends on and have them installed with rake gems:install
  # config.gem "bj"
  # config.gem "hpricot", :version => '0.6', :source => "http://code.whytheluckystiff.net"
  # config.gem "sqlite3-ruby", :lib => "sqlite3"
  # config.gem "aws-s3", :lib => "aws/s3"

  # Only load the plugins named here, in the order given (default is alphabetical).
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

  # Skip frameworks you're not going to use. To use Rails without a database,
  # you must remove the Active Record framework.
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector, :forum_observer
  config.active_record.observers = :activity_observer, :balance_observer

  # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
  # Run "rake -D time" for a list of tasks for finding time zone names.
  config.time_zone = 'UTC'

  # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
  # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}')]
  #config.i18n.default_locale = :ru

  #ActiveSupport::CoreExtensions::Date::Conversions::DATE_FORMATS[:default]='%m/%d/%Y'
  #Time::DATE_FORMATS[:default] = '%Y-%m-%d %H:%M:%S'

  #ActiveSupport::CoreExtensions::Time::Conversions::DATE_FORMATS.merge!(:default => '%m/%d/%Y',  :date_time12  => "%m/%d/%Y %I:%M%p",  :date_time24  => "%m/%d/%Y %H:%M")
  #ActiveSupport::CoreExtensions::Time::Conversions::DATE_FORMATS.merge!(:default => '%Y.%m.%d')

  config.gem 'will_paginate', :version => '~> 2.3.16'
end

ExceptionNotification::Notifier.configure_exception_notifier do |config|
  config[:app_name]                 = "[Azalo]"
  config[:sender_address]           = "error@azalo.net"
  config[:exception_recipients]     =  %w(admin@example.com admin@gmail.com)  # You need to set at least one recipient if you want to get the notifications

  config[:subject_prepend]          = "[Azalo.net ERROR] "

  # In a local environment only use this gem to render, never email
  #defaults to false - meaning by default it sends email.  Setting true will cause it to only render the error pages, and NOT email.
  config[:skip_local_notification]  = false
  # Error Notification will be sent if the HTTP response code for the error matches one of the following error codes
  config[:notify_error_codes]       = %W( 404 405 500 503 )
  # Error Notification will be sent if the error class matches one of the following error classes
  config[:notify_error_classes]     = %W( )
  # What should we do for errors not listed?
  config[:notify_other_errors]      = true
  # If you set this SEN will attempt to use git blame to discover the person who made the last change to the problem code
  config[:git_repo_path]            = nil # ssh://git@blah.example.com/repo/webapp.git
end

Page_id_custom_field_id = 3;
Task_id_custom_field_id = 4;

Admin_email = 'admin@example.com admin@gmail.com'
