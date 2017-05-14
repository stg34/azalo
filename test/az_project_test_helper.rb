ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'
require 'declarative_authorization/maintenance'

class ActiveSupport::TestCase
  
  def logger
    RAILS_DEFAULT_LOGGER
  end

  def create_project(user, owner, name, seed = nil)
    return create_project_internal(user, owner, name, seed, true)
  end

  def create_project2(user, owner, name, public_access)
    return create_project_internal(user, owner, name, nil, public_access)
  end

  def create_project_internal(user, owner, name, seed, public_access)
    Authorization.current_user = user
    prj = AzProject.create(name, owner, user, public_access)
    if seed != nil
      prj.seed = seed
    end
    prj.customer = 'customer'
    ret = prj.save
    unless ret
      logger.error(show_errors(prj.errors))
      return nil
    end
    return prj
  end

  def compare_project_tree_structure(copy)
    all_pages = copy.get_full_pages_list
    all_pages.each do |page|
      original = page.original
      original_ids = original.children.collect{|c| c.id}
      original_ids_over_copies = []
      page.children.each do |c|
        original_ids_over_copies << c.original.id
      end
      original_ids.sort!
      original_ids_over_copies.sort!
      #puts "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXx"
      #puts original_ids.inspect
      #puts original_ids_over_copies.inspect
      #puts "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXx"
      assert(original_ids == original_ids_over_copies)
    end
  end

  def compare_project_and_copy(original, copy)

    compare_project_tree_structure(copy)

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

        #puts file_name_o
        #puts file_name_c

        assert file_name_o != file_name_c
        assert File.basename(file_name_o) == File.basename(file_name_c)
        assert File.exist?(file_name_c)
        assert File.size(file_name_c) == File.size(file_name_o)
      end
    end

    original.az_pages.each do |p|
      #puts p.inspect
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

    original.az_base_data_types.each do |dt|
      if dt.class == AzStructDataType
        data_types_c = get_copies_by_original(AzStructDataType, [dt])[dt]
        data_type_c = data_types_c[0]
        assert_not_nil data_type_c
        compare_struct_data_type_and_copy(dt, data_type_c)
      end

      if dt.class == AzCollectionDataType
        data_types_c = get_copies_by_original(AzCollectionDataType, [dt])[dt]
        data_type_c = data_types_c[0]
        assert_not_nil data_type_c
        compare_collection_data_type_and_copy(dt, data_type_c)
      end

    end

    commons = [AzCommonsCommon,
               AzCommonsAcceptanceCondition,
               AzCommonsContentCreation,
               AzCommonsPurposeExploitation,
               AzCommonsPurposeFunctional,
               AzCommonsRequirementsHosting,
               AzCommonsRequirementsReliability,
               AzCommonsFunctionality]

    commons.each do |cmc|
      cms = eval("original.#{cmc.to_s.underscore.pluralize}")
      cms.each do |c|
        cms_c = get_copies_by_original(cmc, [c])[c]
        cm_c = cms_c[0]
        assert_not_nil cm_c
        compare_common_and_copy(c, cm_c)
      end
    end

    #pages_c = get_copies_by_original(AzPage, original.az_pages.each_value)

  end

end
