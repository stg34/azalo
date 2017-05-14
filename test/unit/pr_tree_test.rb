require 'test_helper'
require 'az_page_test_helper'

class PrTreeTest < ActiveSupport::TestCase

  test "build tree" do

    Authorization.current_user = nil

    assert is_table_size_equal?(AzProject, 0)
    assert is_table_size_equal?(AzParticipant, 0)
    assert is_table_size_equal?(AzPage, 0)

    user = prepare_user(:user)
    assert_not_nil user
    Authorization.current_user = user

    company = prepare_company(user)
    assert_not_nil company

    project = AzProject.create('project', company, user)
    assert_not_nil project
    assert project.get_full_pages_list.size == 3
    root = project.get_root_page

    pg = create_page(user, company, project, 'A', AzPage::Page_user, 'descr', 'title', 1, root, nil, nil)
    create_page(user, company, project, 'B', AzPage::Page_user, 'descr', 'title', 1, pg, nil, nil)

    assert_equal(3+2, project.get_full_pages_list.size)

    #assert project.az_participants.size == roles.size
    #project.az_participants.each do |p|
    #  assert p.az_user == project.owner.ceo
    #end

    #project_role_ids = project.az_participants.collect{ |p| p.az_rm_role_id }.sort!
    #all_role_ids = roles.collect{ |r| r.id }.sort!

    #assert project_role_ids == all_role_ids

    assert is_table_size_equal?(AzProject, 1)
    #assert is_table_size_equal?(AzRmRole, roles.size)
    #assert is_table_size_equal?(AzParticipant, roles.size)
    assert is_table_size_equal?(AzPage, 3 + 2)

    puts '================================================'
    puts project.id
    puts project.az_pages.size
    prj = AzProject.find(project.id)

    PrTree.build(project)

    project.destroy

    assert is_table_size_equal?(AzProject, 0)
    assert is_table_size_equal?(AzParticipant, 0)
    assert is_table_size_equal?(AzPage, 0)
  
    #project = AzProject.find(6521)
    #PrTree.build(project)
    #assert true
  end
end
