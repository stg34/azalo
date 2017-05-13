require 'test_helper'
require 'az_project_test_helper'
require 'az_project_block_test_helper'
require 'az_page_test_helper'
require 'az_definition_test_helper'
require 'az_common_test_helper'
require 'az_design_test_helper'
require 'az_image_test_helper'
require 'az_variable_test_helper'
require 'az_validator_test_helper'
require 'az_simple_data_type_test_helper'
require 'az_struct_data_type_test_helper'
require 'az_collection_template_test_helper'
require 'az_collection_data_type_test_helper'

class AzBaseProjectStatTest < ActiveSupport::TestCase
  test "test project quality" do

    assert false

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

    assert_equal 0, project_src.stats.size
    project_src.update_stats
    puts '---------------------------------------'
    pp project_src.stat

    assert_equal 1, project_src.stats.size

    favicon = File.new(get_test_files_dir + File::Separator + 'favicon.png', "r")
    project_src.favicon = favicon
    project_src.save

    pages_o = {}
    pages_c = {}

    fd = rand(2)

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

    assert_equal(9, table_size(AzPage))

    # Структура_1
    # |---Переменная_1 : Простой_тип_1
    # |---Переменная_2 : Структура_2
    # |                  |--- Переменная_2_1 : Структура_1
    # |---Переменная_3 : Коллекция<Структура_3>
    # |                  |--- Переменная_3_1 : Простой_тип_2
    # |---Переменная_4 : Коллекция<Структура_1>

    assert is_table_size_equal?(AzVariable, 0)
    assert is_table_size_equal?(AzStructDataType, 0)
    assert is_table_size_equal?(AzCollectionDataType, 0)

    create_validator(user, company, 'validator-name', 'validator-description', 'validator-message', 'validator-condition', nil)

    assert is_table_size_equal?(AzValidator, 1) #TODO Add validators to variables

    simple_types = prepare_simple_data_types(user, company)
    assert_not_nil simple_types

    struct_1 = create_struct_data_type(user, company, 'struct_1', project_src)
    assert_not_nil struct_1

    struct_2 = create_struct_data_type(user, company, 'struct_2', project_src)
    assert_not_nil struct_2

    struct_3 = create_struct_data_type(user, company, 'struct_3', project_src)
    assert_not_nil struct_3

    list_tpl = create_collection_template(user, company, 'list')
    assert_not_nil list_tpl

    struct_1_list = create_collection_data_type(user, company, 'list_of_struct_1', list_tpl, struct_1, project_src)
    assert_not_nil struct_1_list

    struct_3_list = create_collection_data_type(user, company, 'list_of_struct_3', list_tpl, struct_3, project_src)
    assert_not_nil struct_3_list

    assert is_table_size_equal?(AzVariable, 0)
    assert is_table_size_equal?(AzStructDataType, 3)
    assert is_table_size_equal?(AzCollectionDataType, 2)

    vars = {}

    # Переменная_1 : Простой_тип_1
    var_name = "var_name_1"
    vars[var_name] = create_variable(user, company, struct_1, simple_types[rand(simple_types.size)], var_name)
    assert_not_nil vars[var_name]

    # Переменная_2 : Структура_2
    var_name = "var_name_2"
    vars[var_name] = create_variable(user, company, struct_1, struct_2, var_name)
    assert_not_nil vars[var_name]

    # Переменная_3 : Коллекция<Структура_3>
    var_name = "var_name_3"
    vars[var_name] = create_variable(user, company, struct_1, struct_3_list, var_name)
    assert_not_nil vars[var_name]

    # Переменная_4 : Коллекция<Структура_1>
    var_name = "var_name_4"
    vars[var_name] = create_variable(user, company, struct_1, struct_1_list, var_name)
    assert_not_nil vars[var_name]

    # Переменная_2_1 : Структура_1
    var_name = "var_name_2_1"
    vars[var_name] = create_variable(user, company, struct_2, struct_1, var_name)
    assert_not_nil vars[var_name]

    # Переменная_3_1 : Простой_тип_2
    var_name = "var_name_3_1"
    vars[var_name] = create_variable(user, company, struct_3, simple_types[rand(simple_types.size)], var_name)
    assert_not_nil vars[var_name]

    tp = AzTypedPage.new(:az_page_id => pages_o['b_o'].id, :az_base_data_type_id => struct_3_list.id)
    tp.owner_id = pages_o['e_o'].owner_id
    tp.save!

    tp = AzTypedPage.new(:az_page_id => pages_o['e_o'].id, :az_base_data_type_id => struct_2.id)
    tp.owner_id = pages_o['e_o'].owner_id
    tp.save!

    assert is_table_size_equal?(AzVariable, 6)
    assert is_table_size_equal?(AzStructDataType, 3)
    assert is_table_size_equal?(AzCollectionDataType, 2)
    assert false
  end

end
