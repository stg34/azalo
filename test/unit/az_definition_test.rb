require 'test_helper'
require 'az_definition_test_helper'
class AzDefinitionTest < ActiveSupport::TestCase
 # ---------------------------------------------------------------------------
  test 'Create correct AzDefinition' do

    clear_az_db

    Authorization.current_user = nil
    
    assert is_table_size_equal?(AzDefinition, 0)

    user = prepare_user(:user)
    assert_not_nil user

    company = prepare_company(user)
    assert_not_nil company

    assert_not_nil create_definition(user, company, 'name', 'description', nil)

    assert is_table_size_equal?(AzDefinition, 1)
  end
  # ---------------------------------------------------------------------------
  test 'AzDefinition reset seed test' do

    clear_az_db

    Authorization.current_user = nil

    assert is_table_size_equal?(AzDefinition, 0)

    user = prepare_user(:user)
    assert_not_nil user

    company = prepare_company(user)
    assert_not_nil company
    
    definition = create_definition(user, company, 'name', 'description', nil, true)
    assert_not_nil definition

    assert is_table_size_equal?(AzDefinition, 1)
    assert AzDefinition.get_seeds.size == 1

    definition_c = definition.make_copy_definition(company, nil)
    assert definition_c.seed == false

    assert is_table_size_equal?(AzDefinition, 2)
    assert AzDefinition.get_seeds.size == 1

  end
  # ---------------------------------------------------------------------------
  test 'Test update_from_source AzDefinition' do

    clear_az_db
  
    Authorization.current_user = nil

    assert is_table_size_equal?(AzDefinition, 0)

    user_src = prepare_user(:user)
    assert_not_nil user_src

    user_dst = prepare_user(:user)
    assert_not_nil user_dst

    company_src = prepare_company(user_src)
    assert_not_nil company_src

    company_dst = prepare_company(user_dst)
    assert_not_nil company_dst

    def_src = create_definition(user_src, company_src, 'name_src', 'definition_src', nil, true)
    assert_not_nil def_src

    def_dst = create_definition(user_dst, company_dst, 'name_dst', 'definition_dst', nil)
    assert_not_nil def_dst

    def_dst.update_from_source(def_src)

    def_dst.save!

    assert def_dst.name       == def_src.name
    assert def_dst.definition == def_src.definition
    assert def_dst.owner_id   != def_src.owner_id

    assert is_table_size_equal?(AzDefinition, 2)
  end
  # ---------------------------------------------------------------------------
  test 'Test update_from_seed AzDefinition' do

    clear_az_db

    Authorization.current_user = nil

    assert is_table_size_equal?(AzDefinition, 0)

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

    def_src_1 = create_definition(user_src, company_src, 'name_src_1', 'description_src_1', nil)
    assert_not_nil def_src_1

    def_src_2 = create_definition(user_src, company_src, 'name_src_2', 'description_src_2', nil)
    assert_not_nil def_src_2

    def_src_seed_1 = create_definition(user_src, company_src, 'name_src_seed_1', 'description_src_seed_1', nil)
    assert_not_nil def_src_seed_1

    def_src_seed_2 = create_definition(user_src, company_src, 'name_src_seed_2', 'description_src_seed_2', nil)
    assert_not_nil def_src_seed_2

    def_src_seed_1.seed = true
    def_src_seed_2.seed = true
    def_src_seed_1.save!
    def_src_seed_2.save!

    def_dst_1 = create_definition(user_dst, company_dst, 'name_dst_1', 'description_dst_1', nil)
    assert_not_nil def_dst_1

    def_dst_2 = create_definition(user_dst, company_dst, 'name_dst_2', 'description_dst_2', nil)
    assert_not_nil def_dst_2

    assert is_table_size_equal?(AzDefinition, 6)

    # ------------ 2. ----------------
    AzDefinition.update_from_seed(company_dst)

    assert is_table_size_equal?(AzDefinition, 8)
    v1_orig = AzDefinition.find_by_name('name_src_seed_1', :conditions => {:seed => true})
    v1_copy = AzDefinition.find_by_name('name_src_seed_1', :conditions => {:seed => false})
    assert_not_nil v1_orig
    assert_not_nil v1_copy
    assert v1_orig.id = v1_copy.copy_of

    v2_orig = AzDefinition.find_by_name('name_src_seed_2', :conditions => {:seed => true})
    v2_copy = AzDefinition.find_by_name('name_src_seed_2', :conditions => {:seed => false})
    assert_not_nil v2_orig
    assert_not_nil v2_copy
    assert v2_orig.id = v2_copy.copy_of

    # ------------ 3. ----------------
    def_src_seed_3 = create_definition(user_src, company_src, 'name_src_seed_3', 'description_src_seed_3', nil)
    assert_not_nil def_src_seed_3
    def_src_seed_3.seed = true
    def_src_seed_3.save!

    assert is_table_size_equal?(AzDefinition, 9)

    AzDefinition.update_from_seed(company_dst)

    assert is_table_size_equal?(AzDefinition, 10)

    v3_orig = AzDefinition.find_by_name('name_src_seed_3', :conditions => {:seed => true})
    v3_copy = AzDefinition.find_by_name('name_src_seed_3', :conditions => {:seed => false})
    assert_not_nil v3_orig
    assert_not_nil v3_copy
    assert v3_orig.id = v3_copy.copy_of

    # ------------ 4. ----------------
    v3_copy.destroy
    assert is_table_size_equal?(AzDefinition, 9)

    AzDefinition.update_from_seed(company_dst)

    assert is_table_size_equal?(AzDefinition, 10)

    v3_orig = AzDefinition.find_by_name('name_src_seed_3', :conditions => {:seed => true})
    v3_copy = AzDefinition.find_by_name('name_src_seed_3', :conditions => {:seed => false})
    assert_not_nil v3_orig
    assert_not_nil v3_copy
    assert v3_orig.id = v3_copy.copy_of

  end
  # ---------------------------------------------------------------------------

end
