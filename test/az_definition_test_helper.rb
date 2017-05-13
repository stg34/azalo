ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_helper'
require 'declarative_authorization/maintenance'

class ActiveSupport::TestCase
  
  def logger
    Rails.logger
  end

  def create_definition(user, owner, name, definition, project, seed = nil)
    Authorization.current_user = user
    dfn = AzDefinition.new
    dfn.name = name
    dfn.definition = definition
    dfn.owner = owner
    dfn.az_base_project = project
    if seed != nil
      dfn.seed = seed
    end
    unless dfn.save
      logger.error(show_errors(dfn.errors))
      return nil
    end
    return dfn
  end


  def compare_definition_and_copy(original, copy)
    assert_not_nil original
    assert_not_nil copy
    
    if original.az_base_project
      assert_not_nil copy.az_base_project
      assert_equal copy.owner_id, copy.az_base_project.owner_id
    end

    assert_equal original.name, copy.name
    assert_equal original.definition, copy.definition
    assert_equal original.id, copy.copy_of
  end

end
