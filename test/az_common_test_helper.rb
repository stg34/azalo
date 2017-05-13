ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_helper'
require 'declarative_authorization/maintenance'

class ActiveSupport::TestCase
  
  def logger
    Rails.logger
  end

  def create_common(user, owner, common_class, project, seed = nil)
    Authorization.current_user = user
    c = common_class.new
    c.name = "name-#{rand(1000)}"
    c.comment = "comment-#{rand(1000)}"
    c.description = "description-#{rand(1000)}"
    c.owner = owner
    c.az_base_project = project
    if seed != nil
      c.seed = seed
    end
    unless c.save
      logger.error(show_errors(c.errors))
      return nil
    end
    return c
  end

  def create_common_with_name(user, owner, common_class, project, name, seed = nil)
    Authorization.current_user = user
    c = common_class.new
    c.name = name
    c.comment = "comment-#{rand(1000)}"
    c.description = "description-#{rand(1000)}"
    c.owner = owner
    c.az_base_project = project
    if seed != nil
      c.seed = seed
    end
    unless c.save
      logger.error(show_errors(c.errors))
      return nil
    end
    return c
  end

  def compare_common_and_copy(original, copy)
    assert_not_nil original
    assert_not_nil copy
    
    if original.az_base_project
      assert_not_nil copy.az_base_project
      assert_equal copy.owner_id, copy.az_base_project.owner_id
    end

    assert_equal original.name, copy.name
    assert_equal original.description, copy.description
    assert_equal original.comment, copy.comment
    assert_equal original.id, copy.copy_of
  end

end
