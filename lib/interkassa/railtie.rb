require 'interkassa/interkassa_helper'

module Interkassa
  class Railtie < Rails::Railtie
    ActionView::Base.send :include, Interkassa::InterkassaHelper
  end
end
