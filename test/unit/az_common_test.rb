require 'test_helper'
require 'az_common_test_helper'

class AzCommonTest < ActiveSupport::TestCase
  # ---------------------------------------------------------------------------
  test "Create commons test" do
    Authorization.current_user = nil

    user = prepare_user(:user)
    assert_not_nil user
    Authorization.current_user = user

    company = prepare_company(user)
    assert_not_nil company

    project = AzProject.create('project', company, user)
    assert_not_nil project

    commons = [AzCommonsCommon,
               AzCommonsAcceptanceCondition,
               AzCommonsContentCreation,
               AzCommonsPurposeExploitation,
               AzCommonsPurposeFunctional,
               AzCommonsRequirementsHosting,
               AzCommonsRequirementsReliability]

    commons.each do |cmc|
      assert is_table_size_equal?(cmc, 0)
    end

    coms = []

    projects = [project, nil]
    projects.each do |prj|
      commons.each do |cmc|
        com = create_common(user, company, cmc, prj)
        assert_not_nil com
        coms << com
      end
    end

    commons.each do |cmc|
      assert is_table_size_equal?(cmc, 2)
    end

    coms.each do |c|
      c.destroy
    end

    commons.each do |cmc|
      assert is_table_size_equal?(cmc, 0)
    end

  end
  # ---------------------------------------------------------------------------
  test "Copy commons test" do
    Authorization.current_user = nil

    user = prepare_user(:user)
    assert_not_nil user
    Authorization.current_user = user

    company = prepare_company(user)
    assert_not_nil company

    project = AzProject.create('project', company, user)
    assert_not_nil project

    project_dst = AzProject.create('project', company, user)
    assert_not_nil project_dst

    commons = [AzCommonsCommon,
               AzCommonsAcceptanceCondition,
               AzCommonsContentCreation,
               AzCommonsPurposeExploitation,
               AzCommonsPurposeFunctional,
               AzCommonsRequirementsHosting,
               AzCommonsRequirementsReliability]

    commons.each do |cmc|
      assert is_table_size_equal?(cmc, 0)
    end

    coms = []

    projects = [project, nil]
    projects.each do |prj|
      commons.each do |cmc|
        com = create_common(user, company, cmc, prj)
        assert_not_nil com
        coms << com
      end
    end
    
    coms.each do |c|
      c.make_copy_common(company, project_dst)
    end

    copied_commons_by_original = get_copies_by_original(AzCommon, coms)

    copied_commons_by_original.each_pair do |common_o, commons_c|
      assert_not_nil commons_c
      assert commons_c.size > 0
      commons_c.each do |common_c|
        compare_common_and_copy(common_o, common_c)
      end
    end

    commons.each do |cmc|
      assert is_table_size_equal?(cmc, 2*2)
    end

    coms.each do |c|
      c.destroy
    end

    commons.each do |cmc|
      assert is_table_size_equal?(cmc, 2)
    end

    project_dst.destroy

    commons.each do |cmc|
      assert is_table_size_equal?(cmc, 0)
    end

  end
  # ---------------------------------------------------------------------------
  test "AzCommon reset seed test" do

    Authorization.current_user = nil

    user = prepare_user(:user)
    assert_not_nil user
    Authorization.current_user = user

    company = prepare_company(user)
    assert_not_nil company

    project = AzProject.create('project', company, user)
    assert_not_nil project

    project_dst = AzProject.create('project', company, user)
    assert_not_nil project_dst

    commons = [AzCommonsCommon,
               AzCommonsAcceptanceCondition,
               AzCommonsContentCreation,
               AzCommonsPurposeExploitation,
               AzCommonsPurposeFunctional,
               AzCommonsRequirementsHosting,
               AzCommonsRequirementsReliability]

    commons.each do |cmc|
      assert is_table_size_equal?(cmc, 0)
    end

    coms = []

    projects = [project, nil]
    projects.each do |prj|
      commons.each do |cmc|
        com = create_common(user, company, cmc, prj, true)
        assert_not_nil com
        coms << com
      end
    end

    commons.each do |cmc|
      assert is_table_size_equal?(cmc, 2)
    end

    commons.each do |c|
      assert c.get_seeds.size == 2
    end

    coms.each do |c|
      c.make_copy_common(company, project_dst)
    end

    commons.each do |c|
      assert c.get_seeds.size == 2
      assert is_table_size_equal?(c, 4)
    end
    
  end
  # ---------------------------------------------------------------------------
  test "Test update_from_source AzCommon" do

    Authorization.current_user = nil

    assert is_table_size_equal?(AzCommon, 0)

    user_src = prepare_user(:user)
    assert_not_nil user_src

    user_dst = prepare_user(:user)
    assert_not_nil user_dst

    company_src = prepare_company(user_src)
    assert_not_nil company_src

    company_dst = prepare_company(user_dst)
    assert_not_nil company_dst

    com_src = create_common(user_src, company_src, AzCommon, nil, true)
    assert_not_nil com_src

    com_dst = create_common(user_dst, company_dst, AzCommon, nil)
    assert_not_nil com_dst

    com_dst.update_from_source(com_src)

    com_dst.save!

    assert com_dst.name        == com_src.name
    assert com_dst.description == com_src.description
    assert com_dst.comment     == com_src.comment
    assert com_dst.owner_id    != com_src.owner_id

    assert is_table_size_equal?(AzCommon, 2)
  end
  # ---------------------------------------------------------------------------
  test "Test update_from_seed AzCommon" do
    Authorization.current_user = nil

    assert is_table_size_equal?(AzCommon, 0)

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

    com_src_1 = create_common_with_name(user_src, company_src, AzCommon, nil, 'name_src_1')
    assert_not_nil com_src_1

    com_src_2 = create_common_with_name(user_src, company_src, AzCommon, nil, 'name_src_2')
    assert_not_nil com_src_2

    com_src_seed_1 = create_common_with_name(user_src, company_src, AzCommon, nil, 'name_src_seed_1', true)
    assert_not_nil com_src_seed_1

    com_src_seed_2 = create_common_with_name(user_src, company_src, AzCommon, nil, 'name_src_seed_2', true)
    assert_not_nil com_src_seed_2

    com_dst_1 = create_common_with_name(user_dst, company_dst, AzCommon, nil, 'name_dst_1')
    assert_not_nil com_dst_1

    com_dst_2 = create_common_with_name(user_dst, company_dst, AzCommon, nil, 'name_dst_2')
    assert_not_nil com_dst_2

    assert is_table_size_equal?(AzCommon, 6)

    # ------------ 2. ----------------
    AzCommon.update_from_seed(company_dst)

    assert is_table_size_equal?(AzCommon, 8)
    v1_orig = AzCommon.find_by_name('name_src_seed_1', :conditions => {:seed => true})
    v1_copy = AzCommon.find_by_name('name_src_seed_1', :conditions => {:seed => false})
    assert_not_nil v1_orig
    assert_not_nil v1_copy
    assert v1_orig.id = v1_copy.copy_of

    v2_orig = AzCommon.find_by_name('name_src_seed_2', :conditions => {:seed => true})
    v2_copy = AzCommon.find_by_name('name_src_seed_2', :conditions => {:seed => false})
    assert_not_nil v2_orig
    assert_not_nil v2_copy
    assert v2_orig.id = v2_copy.copy_of

    # ------------ 3. ----------------
    com_src_seed_3 = create_common_with_name(user_src, company_src, AzCommon, nil, 'name_src_seed_3', true)
    assert_not_nil com_src_seed_3
    #com_src_seed_3.seed = true
    #com_src_seed_3.save!

    assert is_table_size_equal?(AzCommon, 9)

    AzCommon.update_from_seed(company_dst)

    assert is_table_size_equal?(AzCommon, 10)

    v3_orig = AzCommon.find_by_name('name_src_seed_3', :conditions => {:seed => true})
    v3_copy = AzCommon.find_by_name('name_src_seed_3', :conditions => {:seed => false})
    assert_not_nil v3_orig
    assert_not_nil v3_copy
    assert v3_orig.id = v3_copy.copy_of

    # ------------ 4. ----------------
    v3_copy.destroy
    assert is_table_size_equal?(AzCommon, 9)

    AzCommon.update_from_seed(company_dst)

    assert is_table_size_equal?(AzCommon, 10)

    v3_orig = AzCommon.find_by_name('name_src_seed_3', :conditions => {:seed => true})
    v3_copy = AzCommon.find_by_name('name_src_seed_3', :conditions => {:seed => false})
    assert_not_nil v3_orig
    assert_not_nil v3_copy
    assert v3_orig.id = v3_copy.copy_of

  end
  # ---------------------------------------------------------------------------
  
end
