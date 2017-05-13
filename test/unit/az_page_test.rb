require 'test_helper'
require 'az_project_test_helper'
require 'az_page_test_helper'
require 'az_design_test_helper'
require 'az_image_test_helper'

class AzPageAzPageTypeTest < ActiveSupport::TestCase
  # ---------------------------------------------------------------------------
  test 'Create correct AzPage' do
    Authorization.current_user = nil

    clear_az_db

    assert is_table_size_equal?(AzPage, 0)

    user = prepare_user(:user)
    assert_not_nil user

    company = prepare_company(user)
    assert_not_nil company

    project = create_project(user, company, 'project')
    assert_not_nil project
    root_project = project.get_root_page

    page = create_page(user, company, project, 'name_1', AzPage::Page_user, 'description_1', 'title_1', 1, root_project, nil, nil)
    assert_not_nil page

    page = create_page(user, company, project, 'name_2', AzPage::Page_admin, 'description_2', 'title_2', 1, root_project, nil, nil)
    assert_not_nil page

    assert is_table_size_equal?(AzPage, 4+1)
  end
  # ---------------------------------------------------------------------------
  test 'Create incorrect AzPage' do

    clear_az_db

    Authorization.current_user = nil

    assert is_table_size_equal?(AzPage, 0)

    user = prepare_user(:user)
    assert_not_nil user

    company = prepare_company(user)
    assert_not_nil company

    project = create_project(user, company, 'project')
    assert_not_nil project

    assert is_table_size_equal?(AzPage, 2+1)

    page = create_page(user, company, nil, 'name_1', AzPage::Page_user, 'description_1', 'title_1', 1, nil, nil, nil)
    assert_nil page

    page = create_page(user, company, project, '', AzPage::Page_user, 'description_2', 'title_2', 1, nil, nil, nil)
    assert_nil page

    page = create_page(user, company, project, nil, AzPage::Page_user, 'description_3', 'title_3', 1, nil, nil, nil)
    assert_nil page

    page = create_page(user, company, project, 'name_4', nil, 'description_4', 'title_4', 1, nil, nil, nil)
    assert_nil page

    assert is_table_size_equal?(AzPage, 2+1)
  end
  # ---------------------------------------------------------------------------
  test 'Copy AzPage 1' do

    clear_az_db

    Authorization.current_user = nil

    assert is_table_size_equal?(AzPage, 0)

    user = prepare_user(:user)
    assert_not_nil user

    company = prepare_company(user)
    assert_not_nil company

    project_src = create_project(user, company, 'project')
    assert_not_nil project_src
    root_src = project_src.get_root_page
    assert is_table_size_equal?(AzPage, 3)

    project_dst = create_project(user, company, 'project')
    assert_not_nil project_dst

    assert is_table_size_equal?(AzPage, 6)

    page_o = create_page(user, company, project_src, 'name_1', AzPage::Page_user, 'description_1', 'title_1', 5, root_src, nil, nil)
    assert_not_nil page_o

    assert is_table_size_equal?(AzPage, 7)

    page_c = page_o.make_copy_page(project_dst)

    assert_not_nil page_c

    assert page_c.title == page_o.title
    assert page_c.name == page_o.name
    assert page_c.position == page_o.position
    assert page_c.estimated_time == page_o.estimated_time
    assert page_c.page_type == page_o.page_type
    assert page_c.description == page_o.description
    assert page_c.copy_of == page_o.id

    assert is_table_size_equal?(AzPage, 8)
  end
  # ---------------------------------------------------------------------------
  test 'Copy AzPage 1 (designs and images)' do

    clear_az_db

    Authorization.current_user = nil

    assert is_table_size_equal?(AzPage, 0)
    assert is_table_size_equal?(AzDesign, 0)
    assert is_table_size_equal?(AzImage, 0)

    user = prepare_user(:user)
    assert_not_nil user

    company = prepare_company(user)
    assert_not_nil company

    project_src = create_project(user, company, 'project_src')
    assert_not_nil project_src
    root_src = project_src.get_root_page

    project_dst = create_project(user, company, 'project_dst')
    assert_not_nil project_dst

    page_o = create_page(user, company, project_src, 'name_1', AzPage::Page_user, 'description_1', 'title_1', 5, root_src, nil, nil)
    assert_not_nil page_o

    designs = []
    design = create_design(user, company, 'description_0', page_o)
    assert_not_nil design
    designs << design

    design = create_design(user, company, 'description_1', page_o)
    assert_not_nil design
    designs << design
    
    images = []
    correct_files = get_correct_image_files
    img_file = correct_files[0]

    designs.each do |design|
      (0..1).each do
        image = create_image(user, company, design, img_file)
        assert_not_nil image
        images << image
      end
    end

    assert is_table_size_equal?(AzPage, 5+2)
    assert is_table_size_equal?(AzDesign, designs.size)
    assert is_table_size_equal?(AzImage, images.size)

    page_c = page_o.make_copy_page(project_dst)

    compare_page_and_copy(page_o, page_c)

    assert is_table_size_equal?(AzPage, 8)
    assert is_table_size_equal?(AzDesign, designs.size * 2)
    assert is_table_size_equal?(AzImage, images.size * 2)

    project_src.destroy
    project_dst.destroy

    assert is_table_size_equal?(AzPage, 0)
    assert is_table_size_equal?(AzDesign, 0)
    assert is_table_size_equal?(AzImage, 0)
  end
  # ---------------------------------------------------------------------------
  test 'Destroy design (functionality) source page' do

    clear_az_db

    Authorization.current_user = nil

    assert is_table_size_equal?(AzPage, 0)

    user = prepare_user(:user)
    assert_not_nil user

    company = prepare_company(user)
    assert_not_nil company

    project_src = create_project(user, company, 'project')
    assert_not_nil project_src
    src_root = project_src.get_root_page

    project_dst = create_project(user, company, 'project')
    assert_not_nil project_dst

    page_source_d = create_page(user, company, project_src, 'design source', AzPage::Page_user, 'description_1', 'title_1', 1, src_root, nil, nil)
    assert_not_nil page_source_d

    page_recipient_d = create_page(user, company, project_src, 'design recipient', AzPage::Page_user, 'description_2', 'title_1', 2, src_root, page_source_d, nil)
    assert_not_nil page_recipient_d

    page_source_f = create_page(user, company, project_src, 'functionality source', AzPage::Page_user, 'description_1', 'title_1', 1, src_root, nil, nil)
    assert_not_nil page_source_f

    page_recipient_f = create_page(user, company, project_src, 'functionality recipient', AzPage::Page_user, 'description_2', 'title_1', 2, src_root, nil, page_source_f)
    assert_not_nil page_recipient_f

    page_source_d.destroy
    page_source_f.destroy

    assert_not_nil page_recipient_d.design_source
    assert_not_nil page_recipient_f.functionality_source

    # Перегружаем данные из базы, т.к. переменные в памяти и не изменились после page.destroy()
    page_recipient_d = AzPage.find(page_recipient_d.id)
    page_recipient_f = AzPage.find(page_recipient_f.id)

    assert_nil page_recipient_d.az_design_double_page_id
    assert_nil page_recipient_d.design_source
    assert_nil page_recipient_d.az_functionality_double_page_id
    assert_nil page_recipient_d.functionality_source
    
    assert is_table_size_equal?(AzPage, 6+2)
  end
  # ---------------------------------------------------------------------------
#  test "Copy AzPage 3 (design and functionality source)" do
#    # TODO этот тест нужно будет удалить после реализации аналогичного для проекта
#    # TODO Тест устарел, перенести с коррективами в тест проетка.
#    Authorization.current_user = nil
#
#    assert is_table_size_equal?(AzPage, 0)
#    assert is_table_size_equal?(AzDesign, 0)
#    assert is_table_size_equal?(AzImage, 0)
#
#    user = prepare_user(:user)
#    assert_not_nil user
#
#    company = prepare_company(user)
#    assert_not_nil company
#
#    project_src = create_project(user, company, 'project')
#    assert_not_nil project_src
#    root_src = project_src.get_root_page
#
#    project_dst = create_project(user, company, 'project')
#    assert_not_nil project_dst
#
#    page_ds = create_page(user, company, project_src, 'name_1', AzPage::Page_user, 'design source', 'title_1', 1, root_src, nil, nil)
#    assert_not_nil page_ds
#
#    page_fs = create_page(user, company, project_src, 'name_2', AzPage::Page_user, 'functionality source', 'title_2', 2, root_src, nil, nil)
#    assert_not_nil page_fs
#
#    page_dr = create_page(user, company, project_src, 'name_3', AzPage::Page_user, 'design recipient', 'title_3', 3, root_src, page_ds, nil)
#    assert_not_nil page_dr
#
#    page_fr = create_page(user, company, project_src, 'name_4', AzPage::Page_user, 'functionality recipient', 'title_4', 4, root_src, nil, page_fs)
#    assert_not_nil page_fr
#
#    assert is_table_size_equal?(AzPage, 8+2)
#
#    page_c_ds = page_ds.make_copy(project_dst)
#    page_c_fs = page_fs.make_copy(project_dst)
#    page_c_dr = page_dr.make_copy(project_dst)
#    page_c_fr = page_fr.make_copy(project_dst)
#
#    assert is_table_size_equal?(AzPage, 12+2)
#
#    dst_root = project_dst.get_root_page
#
#    full_pages_list = [dst_root, page_c_ds, page_c_fs, page_c_dr, page_c_fr]
#    project_dst.fix_page_structure(full_pages_list)
#    project_dst.fix_page_references(full_pages_list)
#
#    # Перегружаем данные из базы, т.к. переменные в памяти и не изменились после update_page_sources()
#    page_c_ds = AzPage.find(page_c_ds.id)
#    page_c_fs = AzPage.find(page_c_fs.id)
#    page_c_dr = AzPage.find(page_c_dr.id)
#    page_c_fr = AzPage.find(page_c_fr.id)
#
#    compare_page_and_copy(page_ds, page_c_ds)
#    compare_page_and_copy(page_fs, page_c_fs)
#    compare_page_and_copy(page_dr, page_c_dr)
#    compare_page_and_copy(page_fr, page_c_fr)
#
#    project_src.destroy
#
#    assert is_table_size_equal?(AzPage, 6+1)
#
#    project_dst.destroy
#
#    assert is_table_size_equal?(AzPage, 0)
#  end
  # ---------------------------------------------------------------------------


end
