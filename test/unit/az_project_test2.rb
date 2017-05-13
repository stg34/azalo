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

# require 'test/factories/pages'
require 'factories/page'
class AzProjectTest2 < ActiveSupport::TestCase

  def write_project_yaml(project, file_name = 'test.yaml')
    f0 = File.open(Rails.root + "tmp/#{file_name}", "w")
    puts Rails.root + "tmp/#{file_name}"
    project_hash = project.to_az_hash
    f0.write(project_hash.to_yaml)
    f0.close
  end

  def read_project_yaml(file_name = 'test.yaml')
    return YAML::load(File.read(Rails.root + "tmp/#{file_name}"))
  end

# ---------------------------------------------------------------------------
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

   clear_az_db

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

   assert_equal(9, table_size(AzPage))

   write_project_yaml(project_src)
   project_hash = read_project_yaml

   project_dst = AzProject.build_from_az_hash(project_hash, company)

   compare_project_and_copy(project_src, project_dst)

   assert_equal(table_size(AzPage), 18)

   project_src.destroy

   assert_equal(table_size(AzPage), 9)

   project_dst.destroy

   assert_equal(table_size(AzPage), 0)
 end
 # ---------------------------------------------------------------------------
  test "Copy AzProject 2 (definitions and commons)" do

    clear_az_db

    Authorization.current_user = nil
    commons = AzCommon.get_child_classes

    #assert false # где az_commons_functionalities ?

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

    write_project_yaml(project)
    project_hash = read_project_yaml

    user_dst = prepare_user(:user)
    assert_not_nil user_dst
    Authorization.current_user = user_dst

    company_dst = prepare_company(user_dst)
    assert_not_nil company_dst

    project_c = AzProject.build_from_az_hash(project_hash, company_dst)
    #project_c = project.make_copy(company_dst)

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

    clear_az_db

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

    root_page = project.get_root_page
    root_page.children << block_page_1

    assert_equal(5, table_size(AzPageAzPage))
    assert_equal(1, table_size(AzProject))
    assert_equal(1, table_size(AzProjectBlock))

    assert_equal(3, block.get_full_pages_list.size)
    assert_equal(3, project.get_full_pages_list.size)

    assert_equal(6, table_size(AzPage))

    #block_copy = block.make_copy(project.owner) #pages: 6+3=9
    #block_copy.parent_project = project
    project.components << block
    #assert_equal(6, project.get_full_pages_list.size)

    #project.az_pages[0].add_block(block)
    #project.az_pages[1].add_block(project.az_pages[0].attached_blocks[0])

    assert_equal(1, project.get_project_block_list.size)

    assert_equal(1, table_size(AzProject))
    assert_equal(1, table_size(AzProjectBlock))

    #assert_equal(9, table_size(AzPage))

    #assert_equal 4, project.get_full_pages_list.size

    assert_equal(1, table_size(AzProject))
    #assert_equal(6, table_size(AzPage))

    assert_equal(1, project.components.size)

    #project_c = project.make_copy(company)

    write_project_yaml(project)
    project_hash = read_project_yaml
     
    user_dst = prepare_user(:user)
    assert_not_nil user_dst
    Authorization.current_user = user_dst

    company_dst = prepare_company(user_dst)
    assert_not_nil company_dst

    project_c = AzProject.build_from_az_hash(project_hash, company_dst)
    #project_c = project.make_copy(company_dst)

    assert_equal(1, project_c.components.size)

    compare_project_and_copy(project, project_c)

    assert_equal(project.get_full_pages_list.size, project_c.get_full_pages_list.size)

    assert_equal(1 * 2, table_size(AzProject))
    assert_equal(12, table_size(AzPage))

    project.destroy

    assert_equal(1, table_size(AzProject))
    assert_equal(6, table_size(AzPage))

    project_c.destroy

    assert_equal(table_size(AzProject), 0)
    assert_equal(table_size(AzPage), 0)

  end
 # # ---------------------------------------------------------------------------
 test "Copy Project with designs" do
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

   clear_az_db

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

   assert_equal(9, table_size(AzPage))


   design1 = create_design(user, company, "description", pages_o['a_o'])
   design2 = create_design(user, company, "description", pages_o['c_o'])

   source_files = get_correct_source_files
   create_design_source(user, company, design1, source_files[0])

   image_files = get_correct_image_files
   create_image(user, company, design1, image_files[0])
   create_image(user, company, design2, image_files[1])

   write_project_yaml(project_src)
   project_hash = read_project_yaml

    user_dst = prepare_user(:user)
    assert_not_nil user_dst
    Authorization.current_user = user_dst

    company_dst = prepare_company(user_dst)
    assert_not_nil company_dst

    project_dst = AzProject.build_from_az_hash(project_hash, company_dst)
    #project_dst = project_src.make_copy(company_dst)

   compare_project_and_copy(project_src, project_dst)

   assert_equal(table_size(AzPage), 18)

   project_src.destroy

   assert_equal(table_size(AzPage), 9)

   project_dst.destroy

   assert_equal(table_size(AzPage), 0)
 end


  test 'Copy Project with structures and validators' do

    clear_az_db

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

    write_project_yaml(project_src)
    project_hash = read_project_yaml

    user_dst = prepare_user(:user)
    assert_not_nil user_dst
    Authorization.current_user = user_dst

    company_dst = prepare_company(user_dst)
    assert_not_nil company_dst

    project_dst = AzProject.build_from_az_hash(project_hash, company_dst)
    #project_dst = project_src.make_copy(company_dst)
    project_dst = AzProject.find(project_dst.id)

    assert is_table_size_equal?(AzVariable, 6*2)
    assert is_table_size_equal?(AzStructDataType, 3*2)
    assert is_table_size_equal?(AzCollectionDataType, 2*2)

    compare_project_and_copy(project_src, project_dst)

    assert_equal(table_size(AzPage), 18)

    project_src.destroy

    assert_equal(table_size(AzPage), 9)

    project_dst.destroy

    assert_equal(table_size(AzPage), 0)
  end

  test 'Copy Project with structures, typed_pages and operations' do

    clear_az_db

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

    n = 0

    defaults = {:az_base_project => project_src, :owner => company}
    pages_o['a_o'] = Factory(:az_page, defaults.merge({:parents => [project_src_root] }))
    assert_not_nil pages_o['a_o']

    pages_o['e_o'] = Factory(:az_page, defaults.merge({:parents => [pages_o['a_o']]}))
    assert_not_nil pages_o['e_o']

    pages_o['b_o'] = Factory(:az_page, defaults.merge({:parents => [pages_o['a_o']]}))
    assert_not_nil pages_o['b_o']

    pages_o['c_o'] = Factory(:az_page, defaults.merge({:parents => [pages_o['b_o']]}))
    assert_not_nil pages_o['c_o']

    pages_o['f_o'] = Factory(:az_page, defaults.merge({:parents => [pages_o['e_o']]}))
    assert_not_nil pages_o['f_o']

    pages_o['d_o'] = Factory(:az_page, defaults.merge({:parents => [pages_o['c_o']]}))
    assert_not_nil pages_o['d_o']

    assert_equal(9, table_size(AzPage))

    struct_1 = create_struct_with_variables(user, company, project_src)

    struct_2 = nil
    list_of_struct_1 = nil

    struct_1.az_variables.each do |var|
      if var.name == 'var_2_struct_2'
        struct_2 = var.az_base_data_type
      end
      if var.name == 'var_4_struct_1_list'
        list_of_struct_1 = var.az_base_data_type
      end
    end
    
    assert_not_nil struct_2
    assert_not_nil list_of_struct_1

    assert_equal struct_2.class, AzStructDataType
    assert_equal list_of_struct_1.class, AzCollectionDataType

    tp1 = AzTypedPage.new(:az_page_id => pages_o['b_o'].id, :az_base_data_type_id => list_of_struct_1.id)
    tp1.owner_id = pages_o['e_o'].owner_id
    tp1.save!

    tp2 = AzTypedPage.new(:az_page_id => pages_o['e_o'].id, :az_base_data_type_id => struct_2.id)
    tp2.owner_id = pages_o['e_o'].owner_id
    tp2.save!

    assert is_table_size_equal?(AzOperation, 0)
    operation_edit = AzOperation.create(:crud_name => 'new', :name => 'Создание')
    assert_not_nil operation_edit

    operation_show = AzOperation.create(:crud_name => 'show', :name => 'Отобраение')
    assert_not_nil operation_show
    assert is_table_size_equal?(AzOperation, 2)

    allowed_operation_edit_1 = AzAllowedOperation.new(:az_operation_id => operation_edit.id, 
                                                      :az_typed_page_id => tp1.id,
                                                      :owner_id => company.id)
    allowed_operation_edit_1.save!
    assert_not_nil allowed_operation_edit_1

    allowed_operation_edit_2 = AzAllowedOperation.new(:az_operation_id => operation_edit.id, 
                                                      :az_typed_page_id => tp2.id,
                                                      :owner_id => company.id)
    allowed_operation_edit_2.save!
    assert_not_nil allowed_operation_edit_2

    allowed_operation_show_1 = AzAllowedOperation.new(:az_operation_id => operation_show.id, 
                                                      :az_typed_page_id => tp1.id,
                                                      :owner_id => company.id)
    allowed_operation_show_1.save!
    assert_not_nil allowed_operation_show_1

    assert is_table_size_equal?(AzValidator, 2)
    assert is_table_size_equal?(AzAllowedOperation, 3)
    assert is_table_size_equal?(AzTypedPage, 2)
    assert is_table_size_equal?(AzVariable, 6)
    assert is_table_size_equal?(AzStructDataType, 3)
    assert is_table_size_equal?(AzCollectionDataType, 2)


    write_project_yaml(project_src)
    project_hash = read_project_yaml

    user_dst = prepare_user(:user)
    assert_not_nil user_dst
    Authorization.current_user = user_dst

    company_dst = prepare_company(user_dst)
    assert_not_nil company_dst
    
    project_dst = AzProject.build_from_az_hash(project_hash, company_dst)
    #project_dst = project_src.make_copy(company_dst)

    assert is_table_size_equal?(AzValidator, 2*2)
    assert is_table_size_equal?(AzAllowedOperation, 3*2)
    assert is_table_size_equal?(AzTypedPage, 2*2)
    assert is_table_size_equal?(AzVariable, 6*2)
    assert is_table_size_equal?(AzStructDataType, 3*2)
    assert is_table_size_equal?(AzCollectionDataType, 2*2)

    compare_project_and_copy(project_src, project_dst)

    assert_equal(table_size(AzPage), 18)

    project_src.destroy

    assert_equal(table_size(AzPage), 9)

    project_dst.destroy

    assert_equal(table_size(AzPage), 0)
  end

end
