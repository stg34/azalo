require 'test_helper'
require 'az_collection_template_test_helper'
require 'az_collection_data_type_test_helper'
require 'az_simple_data_type_test_helper'
require 'az_project_test_helper'

class AzCollectionDataTypeTest < ActiveSupport::TestCase
  
  test "Create correct AzCollectionDataType" do
    Authorization.current_user = nil

    assert is_table_size_equal?(AzCollectionDataType, 0)

    user = prepare_user(:user)
    assert_not_nil user

    company = prepare_company(user)
    assert_not_nil company

    project = create_project(user, company, 'project_src')
    assert_not_nil project

    simple_types = prepare_simple_data_types(user, company)
    assert_not_nil simple_types

    ctpl = create_collection_template(user, company, 'list')
    assert_not_nil ctpl

    cdt = create_collection_data_type(user, company, 'list_of_foo', ctpl, simple_types[rand(simple_types.size)], project)
    assert_not_nil cdt

    assert is_table_size_equal?(AzCollectionDataType, 1)
  end

  test "Create incorrect AzCollectionDataType" do
    Authorization.current_user = nil

    assert is_table_size_equal?(AzCollectionDataType, 0)

    user = prepare_user(:user)
    assert_not_nil user

    company = prepare_company(user)
    assert_not_nil company

    project = create_project(user, company, 'project_src')
    assert_not_nil project

    simple_types = prepare_simple_data_types(user, company)
    assert_not_nil simple_types

    ctpl = create_collection_template(user, company, 'list')
    assert_not_nil ctpl

    cdt = create_collection_data_type(user, company, '', ctpl, simple_types[rand(simple_types.size)], project)
    assert_nil cdt

    cdt = create_collection_data_type(user, company, nil, ctpl, simple_types[rand(simple_types.size)], project)
    assert_nil cdt

    cdt = create_collection_data_type(user, company, 'list_of_foo', nil, simple_types[rand(simple_types.size)], project)
    assert_nil cdt

    cdt = create_collection_data_type(user, company, 'list_of_foo', ctpl, nil, project)
    assert_nil cdt

    assert is_table_size_equal?(AzCollectionDataType, 0)
  end

  test "make_copy AzCollectionDataType" do
    Authorization.current_user = nil

    user = prepare_user(:user)
    assert_not_nil user

    company = prepare_company(user)
    assert_not_nil company

    project = create_project(user, company, 'project_src')
    assert_not_nil project

    assert is_table_size_equal?(AzCollectionDataType, 0)

    simple_types = prepare_simple_data_types(user, company)
    assert_not_nil simple_types

    ctpl = create_collection_template(user, company, 'list')
    assert_not_nil ctpl

    cdt = create_collection_data_type(user, company, 'list_of_foo', ctpl, simple_types[rand(simple_types.size)], project)
    assert_not_nil cdt

    assert is_table_size_equal?(AzCollectionDataType, 1)
    assert is_table_size_equal?(AzCollectionTemplate, 1)
    assert is_table_size_equal?(AzSimpleDataType, simple_types.size)

    # Копирование не должно приводить к возникновению новой записи.
    # Возвращается копируемая запись
    cdt1 = cdt.make_copy_data_type(company, project)

    assert cdt1.id != cdt.id

    assert cdt1.copy_of == cdt.id

    assert is_table_size_equal?(AzCollectionDataType, 2)
    assert is_table_size_equal?(AzCollectionTemplate, 1)
    assert is_table_size_equal?(AzSimpleDataType, simple_types.size)

  end

end
