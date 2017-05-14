ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'
require 'az_allowed_operation_test_helper'
require 'declarative_authorization/maintenance'

class ActiveSupport::TestCase

  def compare_typed_page_and_copy(original, copy)
    assert_not_nil original
    assert_not_nil copy
    assert_equal original.id, copy.copy_of
    assert_equal copy.owner.id, copy.az_page.owner.id
    assert_equal original.az_page.id, copy.az_page.copy_of

    original_allowed_operations = original.az_allowed_operations
    copied_allowed_operations_by_original = get_copies_by_original(AzAllowedOperation, original_allowed_operations)
    p copied_allowed_operations_by_original

    AzAllowedOperation.all.each do |op|
      puts '+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++=='
      p op
    end
    copied_allowed_operations_by_original.each_pair do |original_op, copies|
      assert_not_nil copies
      assert copies.size > 0
      copies.each do |copy_allowed_operation|
        compare_allowed_operation_and_copy(original_op, copy_allowed_operation)
      end
    end
  end

end
