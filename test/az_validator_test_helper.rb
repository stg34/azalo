ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_helper'
require 'declarative_authorization/maintenance'

class ActiveSupport::TestCase
  
  def logger
    Rails.logger
  end

  def create_validator(user, owner, name, description, message, condition, variable, seed = nil)
    Authorization.current_user = user
    v = AzValidator.new
    v.name = name
    v.owner = owner
    v.message = message
    v.description = description
    v.condition = condition
    v.az_variable = variable
    if seed != nil
      v.seed = seed
    end
    ret = v.save
    unless ret
      logger.error(show_errors(v.errors))
      return nil
    end
    return v
  end

  def compare_validator_and_copy(original, copy)
    assert_not_nil original
    assert_not_nil copy
   
    assert_equal original.name, copy.name
    assert_equal original.description, copy.description
    assert_equal original.description, copy.description
    assert_equal original.condition, copy.condition
    assert_equal original.message, copy.message
    assert_equal original.id, copy.copy_of
    assert_not_equal original.az_variable_id, copy.az_variable_id
    assert_not_equal original.owner_id, copy.owner_id
  end

end
