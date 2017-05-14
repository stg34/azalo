ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'
require 'declarative_authorization/maintenance'

class ActiveSupport::TestCase

  def create_variable(user, owner, struct, data_type, name)
    Authorization.current_user = user
    var = AzVariable.new
    var.name = name
    var.owner = owner
    var.az_base_data_type = data_type
    var.az_struct_data_type = struct
    ret = var.save
    unless ret
      logger.error(show_errors(var.errors))
      return nil
    end
    return var
  end

  def compare_variable_and_copy(original, copy)
    if original != nil
      assert_not_nil copy
    end
    assert_not_equal original.id,       copy.id
    assert_equal original.name,         copy.name
    assert_equal original.id,           copy.copy_of
    assert_equal original.description,  copy.description
    if original.az_base_data_type.type == 'AzSimpleDataType'
      assert_equal original.az_base_data_type.id, copy.az_base_data_type.id
    else
      assert_not_equal original.az_base_data_type.id, copy.az_base_data_type.id
      assert_equal original.az_base_data_type.id, copy.az_base_data_type.copy_of
    end

    original_validators = original.az_validators
    copied_validators_by_original = get_copies_by_original(AzValidator, original_validators)

    copied_validators_by_original.each_pair do |original_validator, copies|
      assert_not_nil copies
      assert copies.size > 0
      copies.each do |copy_validator|
        compare_validator_and_copy(original_validator, copy_validator)
      end
    end

  end

end
