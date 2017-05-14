require 'test_helper'
#require 'az_project_test_helper'
require 'az_design_test_helper'
require 'az_project_test_helper'
require 'az_page_test_helper'

class AzDesignTest < ActiveSupport::TestCase

  # ---------------------------------------------------------------------------
  test "Create correct AzDesign" do
    Authorization.current_user = nil

    assert is_table_size_equal?(AzDesign, 0)

    user = prepare_user(:user)
    assert_not_nil user

    company = prepare_company(user)
    assert_not_nil company

    project = create_project(user, company, 'project')
    assert_not_nil project

    project_root_page = project.get_root_page

    page = create_page(user, company, project, 'name_1', AzPage::Page_user, 'description_1', 'title_1', 1, project_root_page, nil, nil)
    assert_not_nil page

    assert create_design(user, company, 'description', page)

    assert is_table_size_equal?(AzDesign, 1)
  end
  # ---------------------------------------------------------------------------
  test "Create incorrect AzDesign" do
    Authorization.current_user = nil

    assert is_table_size_equal?(AzDesign, 0)

    user = prepare_user(:user)
    assert_not_nil user

    company = prepare_company(user)
    assert_not_nil company

    project = create_project(user, company, 'project')
    assert_not_nil project

    project_root_page = project.get_root_page

    page = create_page(user, company, project, 'name_1', AzPage::Page_user, 'description_1', 'title_1', 1, project_root_page, nil, nil)
    assert_not_nil page

    assert_nil create_design(user, company, '', page)

    assert_nil create_design(user, company, nil, page)

    assert_nil create_design(user, company, 'description', nil)

    assert is_table_size_equal?(AzDesign, 0)
  end
  # ---------------------------------------------------------------------------
end
