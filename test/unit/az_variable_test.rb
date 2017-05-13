require 'test_helper'
require 'az_variable_test_helper'
require 'az_simple_data_type_test_helper'
require 'az_struct_data_type_test_helper'
require 'az_project_test_helper'
require 'az_validator_test_helper'

class AzVariableTest < ActiveSupport::TestCase

  #include Authorization::TestHelper

  # ---------------------------------------------------------------------------
  test "Create correct AzVariable" do

    clear_az_db

    Authorization.current_user = nil

    assert is_table_size_equal?(AzVariable, 0)

    user = prepare_user(:user)
    assert_not_nil user

    company = prepare_company(user)
    assert_not_nil company

    simple_types = prepare_simple_data_types(user, company)
    assert_not_nil simple_types

    project = create_project(user, company, 'project')
    assert_not_nil project

    struct = create_struct_data_type(user, company, 'struct', project)
    assert_not_nil struct

    Var_num_1 = 10

    (1..Var_num_1).each do
      ret = create_variable(user, company, struct, simple_types[rand(simple_types.size)], "var_name_#{rand(10000)}")
      assert_not_nil ret
    end

    assert is_table_size_equal?(AzVariable, Var_num_1)
  end
  # ---------------------------------------------------------------------------
  test "Create incorrect AzVariable" do

    clear_az_db

    Authorization.current_user = nil

    assert is_table_size_equal?(AzVariable, 0)

    user = prepare_user(:user)
    assert_not_nil user

    company = prepare_company(user)
    assert_not_nil company

    project = create_project(user, company, 'project')
    assert_not_nil project

    struct = create_struct_data_type(user, company, 'struct', project)
    assert_not_nil struct

    simple_types = prepare_simple_data_types(user, company)
    assert_not_nil simple_types

    ret = create_variable(user, company, struct, simple_types[0], '')
    assert_nil ret

    ret = create_variable(user, company, struct, simple_types[0], nil)
    assert_nil ret

    ret = create_variable(user, company, struct, nil, 'fafa')
    assert_nil ret

    ret = create_variable(user, company, nil, simple_types[0], 'kuku')
    assert_nil ret

    assert is_table_size_equal?(AzVariable, 0)
  end
  # ---------------------------------------------------------------------------
  test "AzVariable.make_copy() 1" do

    clear_az_db

    Authorization.current_user = nil

    assert is_table_size_equal?(AzVariable, 0)

    user = prepare_user(:user)
    assert_not_nil user

    company = prepare_company(user)
    assert_not_nil company

    project = create_project(user, company, 'project')
    assert_not_nil project

    simple_types = prepare_simple_data_types(user, company)
    assert_not_nil simple_types

    o_struct = create_struct_data_type(user, company, 'struct', project)
    assert_not_nil o_struct

    c_struct = create_struct_data_type(user, company, 'struct', project)
    assert_not_nil c_struct

    o_var = create_variable(user, company, o_struct, simple_types[rand(simple_types.size)], "var_name_#{rand(10000)}")
    assert_not_nil o_var

    c_var = o_var.make_copy_variable(company, project, c_struct)

    assert o_var.name == c_var.name
    assert o_var.az_base_data_type_id == c_var.az_base_data_type_id

    assert is_table_size_equal?(AzVariable, 2)
    assert is_table_size_equal?(AzSimpleDataType, simple_types.size)
    assert is_table_size_equal?(AzStructDataType, 2)
    assert is_table_size_equal?(AzCollectionDataType, 0)
  end
  # ---------------------------------------------------------------------------
  test "AzVariable.make_copy() 2" do

    clear_az_db

    Authorization.current_user = nil

    assert is_table_size_equal?(AzVariable, 0)
    assert is_table_size_equal?(AzValidator, 0)

    user = prepare_user(:user)
    assert_not_nil user

    company = prepare_company(user)
    assert_not_nil company

    project = create_project(user, company, 'project')
    assert_not_nil project

    simple_types = prepare_simple_data_types(user, company)
    assert_not_nil simple_types

    o_struct = create_struct_data_type(user, company, 'struct', project)
    assert_not_nil o_struct

    c_struct = create_struct_data_type(user, company, 'struct', project)
    assert_not_nil c_struct

    o_var = create_variable(user, company, o_struct, simple_types[rand(simple_types.size)], "var_name_#{rand(10000)}")
    assert_not_nil o_var

    val = create_validator(user, company, 'name', 'description', 'message', "conditions", o_var)
    assert_not_nil val

    assert o_var.az_validators.size == 1

    assert is_table_size_equal?(AzVariable, 1)
    assert is_table_size_equal?(AzValidator, 1)

    c_var = o_var.make_copy_variable(company, project, c_struct)

    assert o_var.az_validators.size == 1
    assert c_var.az_validators.size == 1

    assert o_var.az_validators[0].id == c_var.az_validators[0].copy_of
    assert o_var.az_validators[0].name == c_var.az_validators[0].name
    assert o_var.az_validators[0].description == c_var.az_validators[0].description
    assert o_var.az_validators[0].message == c_var.az_validators[0].message
    assert o_var.az_validators[0].condition == c_var.az_validators[0].condition

    assert o_var.name == c_var.name
    assert o_var.az_base_data_type_id == c_var.az_base_data_type_id

    assert is_table_size_equal?(AzVariable, 2)
    assert is_table_size_equal?(AzValidator, 2)
  end
  # ---------------------------------------------------------------------------

end
