require "interkassa/version"
require 'interkassa/request'
require 'interkassa/response'
#require 'interkassa/railtie' if defined?(Rails)

module Interkassa
  INTERKASSA_API_VERSION = '1.2'
  INTERKASSA_ENDPOINT_URL="http://www.interkassa.com/lib/payment.php"

  @default_options = {}
  class << self; attr_accessor :default_options; end

  class Exception < ::Exception; end
  class InvalidResponse < Exception; end
end

