ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_helper'
require 'declarative_authorization/maintenance'

class ActiveSupport::TestCase
  
  def logger
    Rails.logger
  end

  def create_collection_template(user, owner, name)
    Authorization.current_user = user
    ctpl = AzCollectionTemplate.new
    ctpl.name = name
    ctpl.owner = owner

    unless ctpl.save
      logger.error(show_errors(ctpl.errors))
      return nil
    end
    return ctpl
  end

end
