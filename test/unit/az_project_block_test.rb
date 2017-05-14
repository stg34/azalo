require 'test_helper'
require 'az_project_test_helper'
require 'az_project_block_test_helper'
require 'az_page_test_helper'
require 'az_definition_test_helper'
require 'az_common_test_helper'

class AzProjectBlockTest < ActiveSupport::TestCase
  # ---------------------------------------------------------------------------
  test "create AzProjectBlock" do
    Authorization.current_user = nil

    assert is_table_size_equal?(AzProjectBlock, 0)
    assert is_table_size_equal?(AzPage, 0)

    user = prepare_user(:user)
    assert_not_nil user
    Authorization.current_user = user

    company = prepare_company(user)
    assert_not_nil company

    project_block = create_project_block(user, company, 'project block') # pages: 1
    assert_not_nil project_block

    root_page = project_block.get_root_page
    pages_o={}
    pages_o['A'] = create_page(user, company, project_block, 'A', AzPage::Page_user, 'descr', 'title', 1, root_page, nil, nil) # pages: 2
    assert_not_nil pages_o['A']

    pages_o['B'] = create_page(user, company, project_block, 'B', AzPage::Page_user, 'descr', 'title', 2, root_page, nil, nil) # pages: 3
    assert_not_nil pages_o['B']

    assert is_table_size_equal?(AzProjectBlock, 1)
    assert is_table_size_equal?(AzPage, 3)

    project_block.destroy

    assert is_table_size_equal?(AzProjectBlock, 0)
    assert is_table_size_equal?(AzPage, 0)

  end
  # ---------------------------------------------------------------------------
  test "attach AzProjectBlock" do
    Authorization.current_user = nil

    assert is_table_size_equal?(AzProjectBlock, 0)
    assert is_table_size_equal?(AzPage, 0)

    user = prepare_user(:user)
    assert_not_nil user
    Authorization.current_user = user

    company = prepare_company(user)
    assert_not_nil company

    project_block = create_project_block(user, company, 'project') #pages 1 (root page)
    block_root_page = project_block.get_root_page
    assert_not_nil project_block
    assert is_table_size_equal?(AzPage, 1) # root page

    project = create_project(user, company, 'project') #pages 1+3=4

    assert_not_nil project

    pages_o={}

    pages_o['A'] = create_page(user, company, project_block, 'A', AzPage::Page_user, 'descr', 'title', 1, block_root_page, nil, nil) #pages 4 + 1 = 5
    assert_not_nil pages_o['A']

    pages_o['B'] = create_page(user, company, project_block, 'B', AzPage::Page_user, 'descr', 'title', 2, block_root_page, nil, nil) #pages 5 + 1 = 6
    assert_not_nil pages_o['B']

    assert is_table_size_equal?(AzProjectBlock, 1)
    assert is_table_size_equal?(AzProject, 1)
    assert is_table_size_equal?(AzPage, 6)

    block_copy = project_block.make_copy(project.owner) # duplicate block pages 3. pages = 6+3 = 9
    project.components << block_copy
    assert is_table_size_equal?(AzProject, 1)
    assert is_table_size_equal?(AzProjectBlock, 2)
    assert is_table_size_equal?(AzPage, 9)

    project_block.destroy # pages -3 = 6

    assert is_table_size_equal?(AzProjectBlock, 1)
    assert is_table_size_equal?(AzPage, 6)

    project.destroy

    assert is_table_size_equal?(AzProjectBlock, 0)
    assert is_table_size_equal?(AzPage, 0)

  end
  # ---------------------------------------------------------------------------
  test "attach AzProjectBlock with definitions" do
    Authorization.current_user = nil

    assert is_table_size_equal?(AzProject, 0)
    assert is_table_size_equal?(AzProjectBlock, 0)
    assert is_table_size_equal?(AzPage, 0)
    assert is_table_size_equal?(AzDefinition, 0)

    user = prepare_user(:user)
    assert_not_nil user
    Authorization.current_user = user

    company = prepare_company(user)
    assert_not_nil company

    project_block = create_project_block(user, company, 'project') # pages: 1
    root_page = project_block.get_root_page
    assert_not_nil project_block

    project = create_project(user, company, 'project') # pages: 1+3=4
    assert_not_nil project

    definition = create_definition(user, company, 'name', 'definition', project_block)
    assert_not_nil definition

    project_block.add_definition(definition)

    pages_o={}

    pages_o['A'] = create_page(user, company, project_block, 'A', AzPage::Page_user, 'descr', 'title', 1, root_page, nil, nil)  # pages: 1+4=5
    assert_not_nil pages_o['A']

    pages_o['B'] = create_page(user, company, project_block, 'B', AzPage::Page_user, 'descr', 'title', 2, root_page, nil, nil) # pages: 1+5=6
    assert_not_nil pages_o['B']

    assert is_table_size_equal?(AzProjectBlock, 1)
    assert is_table_size_equal?(AzProject, 1)
    assert is_table_size_equal?(AzPage, 6)
    assert is_table_size_equal?(AzDefinition, 2)

    block_copy = project_block.make_copy(project.owner)  # pages: 3+6=9
    project.components << block_copy

    assert is_table_size_equal?(AzProject, 1)
    assert is_table_size_equal?(AzProjectBlock, 2)
    assert is_table_size_equal?(AzPage, 9)
    assert is_table_size_equal?(AzDefinition, 4)

    project_block.destroy

    assert is_table_size_equal?(AzProjectBlock, 1)
    assert is_table_size_equal?(AzPage, 6)
    assert is_table_size_equal?(AzDefinition, 2)
    assert is_table_size_equal?(AzProject, 1)

    project.destroy

    assert is_table_size_equal?(AzProjectBlock, 0)
    assert is_table_size_equal?(AzProject, 0)
    assert is_table_size_equal?(AzPage, 0)
    assert is_table_size_equal?(AzDefinition, 0)

  end
  # ---------------------------------------------------------------------------
  test "AzProjectBlock reset seed test" do

    Authorization.current_user = nil

    user = prepare_user(:user)
    assert_not_nil user
    Authorization.current_user = user

    company = prepare_company(user)
    assert_not_nil company

    assert is_table_size_equal?(AzProjectBlock, 0)

    project = create_project_block(user, company, 'project', true)
    assert_not_nil project

    assert AzProjectBlock.get_seeds.size == 1

    assert is_table_size_equal?(AzProjectBlock, 1)

    project_c = project.make_copy(company)
    assert project_c.seed == false

    assert AzProjectBlock.get_seeds.size == 1

    assert is_table_size_equal?(AzProjectBlock, 2)

  end
  # ---------------------------------------------------------------------------
  test "move definitions" do
    Authorization.current_user = nil

    user = prepare_user(:user)
    assert_not_nil user
    Authorization.current_user = user

    company = prepare_company(user)
    assert_not_nil company

    assert is_table_size_equal?(AzProjectBlock, 0)

    component = create_project_block(user, company, 'component', true)
    assert_not_nil component

    dfn0 = create_definition(user, company, 'name 0', 'dfn 0', nil)
    dfn1 = create_definition(user, company, 'name 1', 'dfn 1', nil)
    dfn2 = create_definition(user, company, 'name 2', 'dfn 2', nil)

    assert is_table_size_equal?(AzDefinition, 3)

    dfn_id = dfn0.id

    component.az_definitions << dfn0
    component.az_definitions << dfn1
    component.az_definitions << dfn2

    assert is_table_size_equal?(AzDefinition, 3)

    assert component.az_definitions[0].position < component.az_definitions[1].position
    assert component.az_definitions[1].position < component.az_definitions[2].position

    assert component.az_definitions[0].definition == 'dfn 0'
    assert component.az_definitions[1].definition == 'dfn 1'
    assert component.az_definitions[2].definition == 'dfn 2'

    component.move_definition_down_tr(dfn_id)

    assert component.az_definitions[1].position < component.az_definitions[0].position
    assert component.az_definitions[0].position < component.az_definitions[2].position

    component.move_definition_down_tr(dfn_id)

    assert component.az_definitions[1].position < component.az_definitions[2].position
    assert component.az_definitions[2].position < component.az_definitions[0].position

    component.move_definition_down_tr(dfn_id)

    assert component.az_definitions[1].position < component.az_definitions[2].position
    assert component.az_definitions[2].position < component.az_definitions[0].position


    component.move_definition_up_tr(dfn_id)

    assert component.az_definitions[1].position < component.az_definitions[0].position
    assert component.az_definitions[0].position < component.az_definitions[2].position

    component.move_definition_up_tr(dfn_id)

    assert component.az_definitions[0].position < component.az_definitions[1].position
    assert component.az_definitions[1].position < component.az_definitions[2].position

    component.move_definition_up_tr(dfn_id)

    assert component.az_definitions[0].position < component.az_definitions[1].position
    assert component.az_definitions[1].position < component.az_definitions[2].position

  end

  # ---------------------------------------------------------------------------


  test "move commons" do
    Authorization.current_user = nil

    user = prepare_user(:user)
    assert_not_nil user
    Authorization.current_user = user

    company = prepare_company(user)
    assert_not_nil company

    assert is_table_size_equal?(AzProjectBlock, 0)

    component = create_project_block(user, company, 'component', true)
    assert_not_nil component


    com0 = create_common_with_name(user, company, AzCommonsFunctionality, component, 'name_src_0')
    com1 = create_common_with_name(user, company, AzCommonsFunctionality, component, 'name_src_1')
    com2 = create_common_with_name(user, company, AzCommonsFunctionality, component, 'name_src_2')

    assert is_table_size_equal?(AzCommonsFunctionality, 3)

    cmn_id = com0.id

    component.az_commons_functionalities << com0
    component.az_commons_functionalities << com1
    component.az_commons_functionalities << com2

    assert is_table_size_equal?(AzCommonsFunctionality, 3)

    assert component.az_commons_functionalities[0].position < component.az_commons_functionalities[1].position
    assert component.az_commons_functionalities[1].position < component.az_commons_functionalities[2].position

    assert component.az_commons_functionalities[0].name == 'name_src_0'
    assert component.az_commons_functionalities[1].name == 'name_src_1'
    assert component.az_commons_functionalities[2].name == 'name_src_2'

    component.move_common_down_tr(cmn_id)
    component.az_commons_functionalities.each{|c| c.reload}

    assert component.az_commons_functionalities[1].position < component.az_commons_functionalities[0].position
    assert component.az_commons_functionalities[0].position < component.az_commons_functionalities[2].position

    component.move_common_down_tr(cmn_id)
    component.az_commons_functionalities.each{|c| c.reload}

    assert component.az_commons_functionalities[1].position < component.az_commons_functionalities[2].position
    assert component.az_commons_functionalities[2].position < component.az_commons_functionalities[0].position

    component.move_common_down_tr(cmn_id)
    component.az_commons_functionalities.each{|c| c.reload}

    assert component.az_commons_functionalities[1].position < component.az_commons_functionalities[2].position
    assert component.az_commons_functionalities[2].position < component.az_commons_functionalities[0].position

    component.move_common_up_tr(cmn_id)
    component.az_commons_functionalities.each{|c| c.reload}

    assert component.az_commons_functionalities[1].position < component.az_commons_functionalities[0].position
    assert component.az_commons_functionalities[0].position < component.az_commons_functionalities[2].position

    component.move_common_up_tr(cmn_id)
    component.az_commons_functionalities.each{|c| c.reload}

    assert component.az_commons_functionalities[0].position < component.az_commons_functionalities[1].position
    assert component.az_commons_functionalities[1].position < component.az_commons_functionalities[2].position

    component.move_common_up_tr(cmn_id)
    component.az_commons_functionalities.each{|c| c.reload}

    assert component.az_commons_functionalities[0].position < component.az_commons_functionalities[1].position
    assert component.az_commons_functionalities[1].position < component.az_commons_functionalities[2].position

  end

  # ---------------------------------------------------------------------------

end
