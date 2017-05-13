ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_helper'
require 'declarative_authorization/maintenance'

class ActiveSupport::TestCase
  
  def logger
    Rails.logger
  end

  def create_project_block(user, owner, name, seed = nil)
    Authorization.current_user = user
    prj = AzProjectBlock.create(name, owner, user)
    #prj = AzProjectBlock.new
    #prj.name = name
    #prj.author = user
    #prj.owner = owner
    prj.customer = "customer-#{rand(1000)}"
    if seed != nil
      prj.seed = seed
    end
    ret = prj.save
    unless ret
      logger.error(show_errors(prj.errors))
      return nil
    end
    return prj
  end

  def compare_project_block_and_copy(original, copy)
    assert_not_nil original
    assert_not_nil copy
    
    assert original.name == copy.name
    assert original.customer == copy.customer
    assert original.az_project_status_id == copy.az_project_status_id
    assert original.layout_time == copy.layout_time
    
    if original.favicon_file_name != nil
      original.favicon.styles.each_pair do |k, v|
        file_name_o = File.expand_path(original.favicon.path(k))
        file_name_c = File.expand_path(copy.favicon.path(k))

        assert file_name_o != file_name_c
        assert File.basename(file_name_o) == File.basename(file_name_c)
        assert File.exist?(file_name_c)
        assert File.size(file_name_c) == File.size(file_name_o)
      end
    end

    original.az_pages.each do |p|
      pages_c = get_copies_by_original(AzPage, [p])[p]
      page_c = pages_c[0]
      assert_not_nil page_c
      compare_page_and_copy(p, page_c)
    end

    original.az_definitions.each do |d|
      defs_c = get_copies_by_original(AzDefinition, [d])[d]
      def_c = defs_c[0]
      assert_not_nil def_c
      compare_definition_and_copy(d, def_c)
    end

  end

end
