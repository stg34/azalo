require 'test_helper'
require 'az_simple_data_type_test_helper'

class AzSimpleDataTypeTest < ActiveSupport::TestCase
  fixtures :az_base_data_types

  #include Authorization::TestHelper
  
  test "Create correct AzSimpleDataType" do
    Authorization.current_user = nil

    assert is_table_size_equal?(AzSimpleDataType, 0)

    user = prepare_user(:user)
    assert user != nil

    company = prepare_company(user)
    assert company != nil

    assert_not_nil create_simple_data_type(user, company, 'name')

    assert is_table_size_equal?(AzSimpleDataType, 1)
  end

  test "Create incorrect AzSimpleDataType" do
    Authorization.current_user = nil

    assert is_table_size_equal?(AzSimpleDataType, 0)

    user = prepare_user(:user)
    assert user != nil

    company = prepare_company(user)
    assert company != nil

    assert_nil create_simple_data_type(user, company, '')
    assert_nil create_simple_data_type(user, company, nil)

    assert is_table_size_equal?(AzSimpleDataType, 0)
  end

  test "make_copy AzSimpleDataType" do
    Authorization.current_user = nil

    user = prepare_user(:user)
    assert_not_nil user

    company = prepare_company(user)
    assert_not_nil company

    assert is_table_size_equal?(AzSimpleDataType, 0)


    sdt = create_simple_data_type(user, company, 'name')
    assert_not_nil sdt

    assert is_table_size_equal?(AzSimpleDataType, 1)

    # Копирование не должно приводить к возникновению новой записи.
    # Возвращается копируемая запись
    project = nil
    sdt1 = sdt.make_copy_data_type(company, project)

    assert sdt1.id == sdt.id

    assert is_table_size_equal?(AzSimpleDataType, 1)

  end

end
