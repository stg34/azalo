ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_helper'
require 'declarative_authorization/maintenance'

class ActiveSupport::TestCase
  
  def logger
    Rails.logger
  end

  def create_simple_data_type(user, owner, name)
    Authorization.current_user = user
    dt = AzSimpleDataType.new
    dt.name = name
    dt.owner = owner
    
    unless dt.save
      logger.error(show_errors(dt.errors))
      return nil
    end
    return dt
  end

  def prepare_simple_data_types(user, owner)
    Authorization.current_user = user

    types = ['Строка', 'Целое', 'Вещественное']
    simple_types = []

    types.each do |tp|
      sdt = create_simple_data_type(user, owner, tp)
      if sdt != nil
        simple_types << sdt
      end
    end

    if simple_types.size == types.size
      return simple_types
    else
      return nil
    end
  end

end
