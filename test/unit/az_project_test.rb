require 'test_helper'
require 'az_project_test_helper'
require 'az_project_block_test_helper'
require 'az_page_test_helper'
require 'az_definition_test_helper'
require 'az_common_test_helper'

class AzProjectTest < ActiveSupport::TestCase
  # ---------------------------------------------------------------------------
#  test "create AzProject" do
#    Authorization.current_user = nil
#
#    assert is_table_size_equal?(AzProject, 0)
#    assert is_table_size_equal?(AzRmRole, 0)
#    assert is_table_size_equal?(AzParticipant, 0)
#    assert is_table_size_equal?(AzPage, 0)
#
#    user = prepare_user(:user)
#    assert_not_nil user
#    Authorization.current_user = user
#
#    company = prepare_company(user)
#    assert_not_nil company
#
#    roles = prepare_az_rm_roles
#    assert_not_nil roles
#
#    project = AzProject.create('project', company, user)
#    assert_not_nil project
#
#    assert_equal(project.az_participants.size, roles.size)
#    project.az_participants.each do |p|
#      assert_equal(p.az_user, project.owner.ceo)
#    end
#
#    project_role_ids = project.az_participants.collect{ |p| p.az_rm_role_id }.sort!
#    all_role_ids = roles.collect{ |r| r.id }.sort!
#
#    assert project_role_ids == all_role_ids
#
#    assert_equal(table_size(AzProject), 1)
#    assert is_table_size_equal?(AzRmRole, roles.size)
#    assert is_table_size_equal?(AzParticipant, roles.size)
#    assert is_table_size_equal?(AzPage, 2)
#
#    project.destroy
#
#    assert is_table_size_equal?(AzProject, 0)
#    assert is_table_size_equal?(AzParticipant, 0)
#    assert is_table_size_equal?(AzPage, 0)
#
#  end
#  # ---------------------------------------------------------------------------
  test "Copy Project" do
    #
    #            ========== B <========== C <========== D
    #            H          |             |             |
    #            H          |<-------------             |
    #            H          |                           |
    #   A <======H          |                           |
    #   ^        H          |             ---------------
    #   |        H          |             |
    #   |        H          V             V
    #   |        ========== E <========== F
    #   |                   |
    #   ---------------------
    # =, H - связи между страницами
    # -, | - связи между источниками

    Authorization.current_user = nil

    assert is_table_size_equal?(AzPage, 0)
    assert is_table_size_equal?(AzDesign, 0)
    assert is_table_size_equal?(AzImage, 0)

    user = prepare_user(:user)
    assert_not_nil user

    company = prepare_company(user)
    assert_not_nil company

    project_src = create_project(user, company, 'project-1') # pages: 3
    project_src_root = project_src.get_root_page
    assert_not_nil project_src

    favicon = File.new(get_test_files_dir + File::Separator + 'favicon.png', "r")
    project_src.favicon = favicon
    project_src.save

    pages_o = {}
    pages_c = {}

    fd = rand(2)
    #fd = 0

    pages_o['a_o'] = create_page(user, company, project_src, 'A', AzPage::Page_user, 'descr', 'title', 1, project_src_root, nil, nil) # pages: 3+1 = 4
    assert_not_nil pages_o['a_o']

    pages_o['e_o'] = create_page(user, company, project_src, 'E', AzPage::Page_user, 'descr', 'title', 5, pages_o['a_o'], fd == 0 ? pages_o['a_o']:nil, fd == 1 ? pages_o['a_o']:nil) # pages: 4+1 = 5
    assert_not_nil pages_o['e_o']

    pages_o['b_o'] = create_page(user, company, project_src, 'B', AzPage::Page_user, 'descr', 'title', 2, pages_o['a_o'], fd == 0 ? pages_o['e_o']:nil, fd == 1 ? pages_o['e_o']:nil) # pages: 5+1 = 6
    assert_not_nil pages_o['b_o']

    pages_o['c_o'] = create_page(user, company, project_src, 'C', AzPage::Page_user, 'descr', 'title', 3, pages_o['b_o'], fd == 0 ? pages_o['e_o']:nil, fd == 1 ? pages_o['e_o']:nil) # pages: 6+1 = 7
    assert_not_nil pages_o['c_o']

    pages_o['f_o'] = create_page(user, company, project_src, 'F', AzPage::Page_user, 'descr', 'title', 6, pages_o['e_o'], nil, nil) # pages: 7+1 = 8
    assert_not_nil pages_o['f_o']

    pages_o['d_o'] = create_page(user, company, project_src, 'D', AzPage::Page_user, 'descr', 'title', 4, pages_o['c_o'], fd == 0 ? pages_o['f_o']:nil, fd == 1 ? pages_o['f_o']:nil) # pages: 7+1 = 9
    assert_not_nil pages_o['d_o']


    #puts "MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM"
    #puts pages_o['e_o'][:az_functionality_double_page_id]
    #puts pages_o['e_o'][:az_design_double_page_id]
    #puts pages_o['e_o'].inspect
    #puts "MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM"


    assert_equal(9, table_size(AzPage))

    project_dst = project_src.make_copy(company)

    compare_project_and_copy(project_src, project_dst)

    assert_equal(table_size(AzPage), 18)

    project_src.destroy

    assert_equal(table_size(AzPage), 9)

    project_dst.destroy

    assert_equal(table_size(AzPage), 0)
  end
  # ---------------------------------------------------------------------------
  test "Copy AzProject 2 (definitions and commons)" do

    Authorization.current_user = nil

    commons = AzCommon.get_child_classes

    assert is_table_size_equal?(AzProject, 0)
    assert is_table_size_equal?(AzDefinition, 0)
    assert is_table_size_equal?(AzCommon, 0)
    assert is_table_size_equal?(AzPage, 0)
    commons.each do |cmc|
      assert is_table_size_equal?(cmc, 0)
    end

    user = prepare_user(:user)
    assert_not_nil user
    Authorization.current_user = user

    company = prepare_company(user)
    assert_not_nil company

    project = AzProject.create('project', company, user)
    assert_not_nil project
    assert_equal(3, project.az_pages.size)

    definition = create_definition(user, company, 'name', 'definition', project)
    assert_not_nil definition

    project.add_definition(definition)

    coms = []

    commons.each do |cmc|
      com = create_common(user, company, cmc, project)
      assert_not_nil com
    end

    assert is_table_size_equal?(AzProject, 1)
    assert is_table_size_equal?(AzDefinition, 2)
    assert is_table_size_equal?(AzCommon, commons.size)
    assert is_table_size_equal?(AzPage, 3)

    puts "1 ======================================================================================="
    project_c = project.make_copy(company)
    puts "2 ======================================================================================="
    compare_project_and_copy(project, project_c)
    puts "3 ======================================================================================="

    assert is_table_size_equal?(AzProject, 1 * 2)
    assert is_table_size_equal?(AzDefinition, 2 * 2)
    assert is_table_size_equal?(AzCommon, commons.size * 2)
    assert is_table_size_equal?(AzPage, 3 * 2)

    project.destroy

    assert is_table_size_equal?(AzProject, 1)
    assert is_table_size_equal?(AzDefinition, 2)
    assert is_table_size_equal?(AzCommon, commons.size)
    assert is_table_size_equal?(AzPage, 3)

    project_c.destroy

    assert is_table_size_equal?(AzProject, 0)
    assert is_table_size_equal?(AzDefinition, 0)
    assert is_table_size_equal?(AzCommon, 0)
    assert is_table_size_equal?(AzPage, 0)

  end
  # ---------------------------------------------------------------------------
  test "Copy AzProject (with assigned block)" do

    Authorization.current_user = nil
    
    assert is_table_size_equal?(AzProject, 0)
    assert is_table_size_equal?(AzProjectBlock, 0)
    assert is_table_size_equal?(AzPage, 0)

    user = prepare_user(:user)
    assert_not_nil user
    Authorization.current_user = user

    company = prepare_company(user)
    assert_not_nil company

    project = AzProject.create('project_with_block', company, user) #pages: 3
    assert_not_nil project
    assert_equal(3, project.az_pages.size)
    assert_equal(1, table_size(AzProject))
    assert_equal(2, table_size(AzPageAzPage))


    # Creating component tree
    #
    #                  ===== block_page_1
    #                  H
    #  root_page <=====H
    #                  H
    #                  ===== block_page_2
    #
    
    block = create_project_block(user, company, "foo")  #pages: 3+1=4
    assert_equal(2, table_size(AzPageAzPage))

    block_root_page = block.get_root_page

    block_page_1 = create_page(user, company, block, 'Block page 1', AzPage::Page_user, 'description', 'title', 0, block_root_page, nil, nil)  #pages: 4+1=5
    assert_equal(3, table_size(AzPageAzPage))
    
    block_page_2 = create_page(user, company, block, 'Block page 2', AzPage::Page_user, 'description', 'title', 0, block_root_page, nil, nil)  #pages: 5+1=6
    assert_equal(4, table_size(AzPageAzPage))

    #block_root_page = block.get_root_page
    #block_root_page.children << block_page_1
    #block_root_page.children << block_page_2

    assert_equal(4, table_size(AzPageAzPage))
    assert_equal(1, table_size(AzProject))
    assert_equal(1, table_size(AzProjectBlock))

    assert_equal(3, block.get_full_pages_list.size)
    assert_equal(3, project.get_full_pages_list.size)

    assert_equal(6, table_size(AzPage))

    puts project.owner_id
    puts project.owner
    block_copy = block.make_copy(project.owner) #pages: 6+3=9
    #block_copy.parent_project = project
    project.components << block_copy
    assert_equal(6, project.get_full_pages_list.size)

    #project.az_pages[0].add_block(block)
    #project.az_pages[1].add_block(project.az_pages[0].attached_blocks[0])

    assert_equal(1, project.get_project_block_list.size)

    assert_equal(1, table_size(AzProject))
    assert_equal(2, table_size(AzProjectBlock))

    assert_equal(9, table_size(AzPage))

    #assert_equal 4, project.get_full_pages_list.size

    assert_equal(1, table_size(AzProject))
    #assert_equal(6, table_size(AzPage))

    puts '-----------------------------------------------------------------------------'
    AzProject.all.each do |p|
      puts p.inspect
    end
    puts '-----------------------------------------------------------------------------'
    AzProjectBlock.all.each do |p|
      puts p.inspect
    end
    puts '-----------------------------------------------------------------------------'

    assert_equal(1, project.components.size)

    project_c = project.make_copy(company)

    assert_equal(1, project_c.components.size)

    compare_project_and_copy(project, project_c)

    assert_equal(project.get_full_pages_list.size, project_c.get_full_pages_list.size)

    assert_equal(1 * 2, table_size(AzProject))
    assert_equal(15, table_size(AzPage))

    project.destroy

    assert_equal(1, table_size(AzProject))
    assert_equal(9, table_size(AzPage))

    project_c.destroy

    assert_equal(table_size(AzProject), 0)
    assert_equal(table_size(AzPage), 3)

  end
  # ---------------------------------------------------------------------------
 test "AzProject reset seed test" do

    Authorization.current_user = nil

    user = prepare_user(:user)
    assert_not_nil user
    Authorization.current_user = user

    company = prepare_company(user)
    assert_not_nil company

    assert is_table_size_equal?(AzProject, 0)

    project = create_project(user, company, 'project-2', true)
    assert_not_nil project

    assert AzProject.get_seeds.size == 1

    assert is_table_size_equal?(AzProject, 1)

    project_c = AzProject.build_from_az_hash(project.to_az_hash, company)
    #project_c = project.make_copy(company)
    assert project_c.seed == false

    assert AzProject.get_seeds.size == 1

    assert is_table_size_equal?(AzProject, 2)

 end
 # ---------------------------------------------------------------------------

end
