ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'
require 'declarative_authorization/maintenance'

class ActiveSupport::TestCase
  
  def logger
    RAILS_DEFAULT_LOGGER
  end

  def create_collection_data_type(user, owner, name, collection, data_type, project)
    Authorization.current_user = user
    cdt = AzCollectionDataType.new
    cdt.name = name
    cdt.owner = owner
    cdt.az_base_project = project
    cdt.az_collection_template = collection
    cdt.az_base_data_type = data_type
    unless cdt.save
      logger.error(show_errors(cdt.errors))
      return nil
    end
    return cdt
  end

  def compare_collection_data_type_and_copy(original, copy)
    assert_equal original.az_collection_template, copy.az_collection_template
    
    #Если коллекция простых типов, то az_base_data_type_id у копии и оригинала один и тот же
    if original.az_base_data_type.is_a?(AzSimpleDataType)
      assert_equal original.az_base_data_type_id, copy.az_base_data_type_id
    else
      if original.az_base_project_id == copy.az_base_project_id # Копия внутри того-же проекта, типы данных имеют тот же id
        assert_equal original.az_base_data_type_id, copy.matrix.az_base_data_type_id
      else  # Копия полученная копированием проекта, типы данных имеют разный id
        assert_not_equal original.az_base_data_type_id, copy.az_base_data_type_id
        assert_equal original.az_base_data_type_id, copy.az_base_data_type.copy_of
      end

    end
    
    assert_equal original.name, copy.name
    assert_equal original.description, copy.description

    assert_not_nil original.az_base_project
    assert_not_nil copy.az_base_project
    assert_equal copy.owner_id, copy.az_base_project.owner_id
  end

end
