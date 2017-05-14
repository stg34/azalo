require 'test_helper'
require 'az_variable_test_helper'
require 'az_validator_test_helper'
require 'az_simple_data_type_test_helper'
require 'az_struct_data_type_test_helper'
require 'az_project_test_helper'

class AzValidatorTest < ActiveSupport::TestCase
  # ---------------------------------------------------------------------------
  test "Create correct AzValidator" do
    Authorization.current_user = nil

    assert is_table_size_equal?(AzValidator, 0)

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

    var = create_variable(user, company, struct, simple_types[0], "var_name")
    assert_not_nil var

    val = create_validator(user, company, 'name', 'description', 'message', "conditions", var)
    assert_not_nil val

    val = create_validator(user, company, 'name', 'description', 'message', "", var)
    assert_not_nil val

    val = create_validator(user, company, 'name', 'description', 'message', nil, var)
    assert_not_nil val

    assert is_table_size_equal?(AzValidator, 3)
  end
  # ---------------------------------------------------------------------------
  test "Create incorrect AzValidator" do
    Authorization.current_user = nil

    assert is_table_size_equal?(AzValidator, 0)

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

    var = create_variable(user, company, struct, simple_types[0], "var_name")
    assert_not_nil var

    val = create_validator(user, company, '', 'description', 'message', "conditions", var)
    assert_nil val

    val = create_validator(user, company, 'name', '', 'message', "conditions", var)
    assert_nil val

    val = create_validator(user, company, 'name', 'description', '', "conditions", var)
    assert_nil val

    val = create_validator(user, company, nil, 'description', 'message', "conditions", var)
    assert_nil val

    val = create_validator(user, company, 'name', nil, 'message', "conditions", var)
    assert_nil val

    val = create_validator(user, company, 'name', 'description', nil, "conditions", var)
    assert_nil val

    assert is_table_size_equal?(AzValidator, 0)
  end
  # ---------------------------------------------------------------------------
  test "AzProjectBlock reset seed test" do

    Authorization.current_user = nil

    user = prepare_user(:user)
    assert_not_nil user
    Authorization.current_user = user

    company = prepare_company(user)
    assert_not_nil company

    project = create_project(user, company, 'project')
    assert_not_nil project

    struct = create_struct_data_type(user, company, 'struct', project)
    assert_not_nil struct

    simple_types = prepare_simple_data_types(user, company)
    assert_not_nil simple_types

    var = create_variable(user, company, struct, simple_types[0], "var_name")
    assert_not_nil var

    assert is_table_size_equal?(AzValidator, 0)

    val = create_validator(user, company, 'name', 'description', 'message', "conditions", var, true)
    assert_not_nil val
    assert val.seed == true
    
    assert AzValidator.get_seeds.size == 1

    val_c = val.make_copy_validator(company, var)
    assert val_c.seed == false

    assert is_table_size_equal?(AzValidator, 2)

    assert AzValidator.get_seeds.size == 1

  end
  # ---------------------------------------------------------------------------
  test "Test update_from_source AzValidator" do
  
    Authorization.current_user = nil

    assert is_table_size_equal?(AzValidator, 0)

    user_src = prepare_user(:user)
    assert_not_nil user_src

    user_dst = prepare_user(:user)
    assert_not_nil user_dst

    company_src = prepare_company(user_src)
    assert_not_nil company_src

    company_dst = prepare_company(user_dst)
    assert_not_nil company_dst

    val_src = create_validator(user_src, company_src, 'name_src', 'description_src', 'message_src', "conditions_src", nil)
    assert_not_nil val_src

    val_dst = create_validator(user_dst, company_dst, 'name_dst', 'description_dst', 'message_dst', "conditions_dst", nil)
    assert_not_nil val_dst

    val_dst.update_from_source(val_src)

    val_dst.save!

    assert val_dst.name        == val_src.name
    assert val_dst.description == val_src.description
    assert val_dst.condition   == val_src.condition
    assert val_dst.message     == val_src.message
    assert val_dst.owner_id    != val_src.owner_id
    
    assert is_table_size_equal?(AzValidator, 2)
  end
  # ---------------------------------------------------------------------------
  test "Test update_from_seed AzValidator" do
    Authorization.current_user = nil

    assert is_table_size_equal?(AzValidator, 0)

    user_src = prepare_user(:user)
    assert_not_nil user_src

    #user_dst = prepare_user(:user)
    #assert_not_nil user_dst

    company_src = prepare_company(user_src)
    assert_not_nil company_src

    user_dst = user_src

    #company_dst = prepare_company(user_dst)
    #assert_not_nil company_dst

    # 1.
    # name_src_1
    # name_src_2
    # name_src_seed_1
    # name_src_seed_2
    #
    # name_dst_1
    # name_dst_2

    # 2. update_from_seed
    # name_src_1
    # name_src_2
    # name_src_seed_1
    # name_src_seed_2
    #
    # name_dst_1
    # name_dst_2
    # name_src_seed_1 (copy_of name_src_seed_1) (should be copied)
    # name_src_seed_2 (copy_of name_src_seed_1) (should be copied)

    # 3. update_from_seed
    # name_src_1
    # name_src_2
    # name_src_seed_1
    # name_src_seed_2
    # name_src_seed_3 (new)
    #
    # name_dst_1
    # name_dst_2
    # name_src_seed_1 (copy_of name_src_seed_1)
    # name_src_seed_2 (copy_of name_src_seed_2)
    # name_src_seed_3 (copy_of name_src_seed_3) (should be added)

    # 4. update_from_seed
    # name_src_1
    # name_src_2
    # name_src_seed_1
    # name_src_seed_2
    # name_src_seed_3
    #
    # name_dst_1
    # name_dst_2
    # name_src_seed_1 (copy_of name_src_seed_1) (delete) (should be restored)
    # name_src_seed_2 (copy_of name_src_seed_2)
    # name_src_seed_3 (copy_of name_src_seed_3)

    company_dst = company_src

    val_src_1 = create_validator(user_src, company_src, 'name_src_1', 'description_src_1', 'message_src_1', "conditions_src_1", nil)
    assert_not_nil val_src_1

    val_src_2 = create_validator(user_src, company_src, 'name_src_2', 'description_src_2', 'message_src_2', "conditions_src_2", nil)
    assert_not_nil val_src_2

    val_src_seed_1 = create_validator(user_src, company_src, 'name_src_seed_1', 'description_src_seed_1', 'message_src_seed_1', "conditions_src_seed_1", nil)
    assert_not_nil val_src_seed_1

    val_src_seed_2 = create_validator(user_src, company_src, 'name_src_seed_2', 'description_src_seed_2', 'message_src_seed_2', "conditions_src_seed_2", nil)
    assert_not_nil val_src_seed_2

    val_src_seed_1.seed = true
    val_src_seed_2.seed = true
    val_src_seed_1.save!
    val_src_seed_2.save!

    val_dst_1 = create_validator(user_dst, company_dst, 'name_dst_1', 'description_dst_1', 'message_dst_1', "conditions_dst_1", nil)
    assert_not_nil val_dst_1

    val_dst_2 = create_validator(user_dst, company_dst, 'name_dst_2', 'description_dst_2', 'message_dst_2', "conditions_dst_2", nil)
    assert_not_nil val_dst_2

    assert is_table_size_equal?(AzValidator, 6)

    # ------------ 2. ----------------
    AzValidator.update_from_seed(company_dst)

    assert is_table_size_equal?(AzValidator, 8)
    v1_orig = AzValidator.find_by_name('name_src_seed_1', :conditions => {:seed => true})
    v1_copy = AzValidator.find_by_name('name_src_seed_1', :conditions => {:seed => false})
    assert_not_nil v1_orig
    assert_not_nil v1_copy
    assert v1_orig.id = v1_copy.copy_of

    v2_orig = AzValidator.find_by_name('name_src_seed_2', :conditions => {:seed => true})
    v2_copy = AzValidator.find_by_name('name_src_seed_2', :conditions => {:seed => false})
    assert_not_nil v2_orig
    assert_not_nil v2_copy
    assert v2_orig.id = v2_copy.copy_of

    # ------------ 3. ----------------
    val_src_seed_3 = create_validator(user_src, company_src, 'name_src_seed_3', 'description_src_seed_3', 'message_src_seed_3', "conditions_src_seed_3", nil)
    assert_not_nil val_src_seed_3
    val_src_seed_3.seed = true
    val_src_seed_3.save!

    assert is_table_size_equal?(AzValidator, 9)

    AzValidator.update_from_seed(company_dst)

    assert is_table_size_equal?(AzValidator, 10)

    v3_orig = AzValidator.find_by_name('name_src_seed_3', :conditions => {:seed => true})
    v3_copy = AzValidator.find_by_name('name_src_seed_3', :conditions => {:seed => false})
    assert_not_nil v3_orig
    assert_not_nil v3_copy
    assert v3_orig.id = v3_copy.copy_of

    # ------------ 4. ----------------
    v3_copy.destroy
    assert is_table_size_equal?(AzValidator, 9)

    AzValidator.update_from_seed(company_dst)

    assert is_table_size_equal?(AzValidator, 10)

    v3_orig = AzValidator.find_by_name('name_src_seed_3', :conditions => {:seed => true})
    v3_copy = AzValidator.find_by_name('name_src_seed_3', :conditions => {:seed => false})
    assert_not_nil v3_orig
    assert_not_nil v3_copy
    assert v3_orig.id = v3_copy.copy_of

  end
  # ---------------------------------------------------------------------------

end
