ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_helper'
require 'declarative_authorization/maintenance'

class ActiveSupport::TestCase

  def compare_allowed_operation_and_copy(original, copy)
    assert_not_nil original
    assert_not_nil copy
    assert_equal original.az_operation_id, copy.az_operation_id
    assert_equal original.az_typed_page.id, copy.az_typed_page.copy_of
    assert_equal original.id, copy.copy_of 
    assert_equal copy.owner_id, copy.az_typed_page.owner_id
  end

end
