require 'test_helper'
require 'az_image_test_helper'
require 'az_page_test_helper'
require 'az_design_test_helper'
require 'az_project_test_helper'

class AzImageTest < ActiveSupport::TestCase
  # ---------------------------------------------------------------------------
  test 'Create correct AzImage' do
    clear_az_db
    Authorization.current_user = nil

    test_files_dir = get_test_files_dir

    assert is_table_size_equal?(AzImage, 0)

    user = prepare_user(:user)
    assert_not_nil user

    company = prepare_company(user)
    assert_not_nil company

    project = create_project(user, company, 'project')
    assert_not_nil project

    project_root_page = project.get_root_page

    page = create_page(user, company, project, 'name_1', AzPage::Page_user, 'description_1', 'title_1', 1, project_root_page, nil, nil)
    assert_not_nil page

    design = create_design(user, company, 'description', page)
    assert_not_nil design

    correct_files = get_correct_image_files

    correct_files.each do |img_file|
      assert_not_nil create_image(user, company, design, img_file)
    end

    assert is_table_size_equal?(AzImage, correct_files.size)
  end
  # ---------------------------------------------------------------------------
  test 'Create AzImage with incorrect mime-type' do
    clear_az_db
    Authorization.current_user = nil

    test_files_dir = get_test_files_dir

    assert is_table_size_equal?(AzImage, 0)

    user = prepare_user(:user)
    assert_not_nil user

    company = prepare_company(user)
    assert_not_nil company

    project = create_project(user, company, 'project')
    assert_not_nil project

    project_root_page = project.get_root_page

    page = create_page(user, company, project, 'name_1', AzPage::Page_user, 'description_1', 'title_1', 1, project_root_page, nil, nil)
    assert_not_nil page

    design = create_design(user, company, 'description', page)
    assert_not_nil design

    incorrect_files = get_incorrect_image_files

    incorrect_files.each do |img_file|
      assert_nil create_image(user, company, design, img_file)
    end

    assert is_table_size_equal?(AzImage, 0)
  end
  # ---------------------------------------------------------------------------
  test 'Create AzImage with incorrect file size' do
    clear_az_db
    Authorization.current_user = nil

    test_files_dir = File.expand_path(File.dirname(__FILE__) + "/../test_files/")

    assert is_table_size_equal?(AzImage, 0)

    user = prepare_user(:user)
    assert_not_nil user

    company = prepare_company(user)
    assert_not_nil company

    project = create_project(user, company, 'project')
    assert_not_nil project

    project_root_page = project.get_root_page

    page = create_page(user, company, project, 'name_1', AzPage::Page_user, 'description_1', 'title_1', 1, project_root_page, nil, nil)
    assert_not_nil page

    design = create_design(user, company, 'description', page)
    assert_not_nil design

    img_file = File.new(test_files_dir + File::Separator + 'image_1600x1200.png', "r")
    assert_nil create_image(user, company, design, img_file)

    assert is_table_size_equal?(AzImage, 0)
  end
  # ---------------------------------------------------------------------------
end
