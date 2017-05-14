ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'
require 'declarative_authorization/maintenance'
require 'az_image_test_helper'
require 'az_typed_page_test_helper'

class ActiveSupport::TestCase

  def create_page(user, owner, project, name, page_type, description, title, position, parent_page, design_source, functionality_source)
    Authorization.current_user = user
    page = AzPage.new
    page.name = name
    page.owner = owner
    page.az_base_project = project
    page.page_type = page_type
    page.description = description
    page.title = title
    page.position = position
    if parent_page
      page.parents = [parent_page]
    end
    page.design_source = design_source
    page.functionality_source = functionality_source
    
    unless page.save
      logger.error(show_errors(page.errors))
      return nil
    end
    return page
  end

  def create_page_with_design(user, project, parent_page)
    Authorization.current_user = user
    page = AzPage.new
    page.name = "page-name-#{rand(1000)}"
    page.owner = project.owner
    page.az_base_project = project
    #page.page_type = page_type
    page.description = "page-description-#{rand(1000)}"
    page.title = "page-title-#{rand(1000)}"
    page.position = rand(10000)
    if parent_page
      page.parents = [parent_page]
    end

    designs = []
    design = create_design(user, project.owner, 'description_0', page)
    assert_not_nil design
    designs << design

    design = create_design(user, project.owner, 'description_1', page)
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

    #page.design_source = design_source
    #page.functionality_source = functionality_source

    page.save!
    return page
  end



  def compare_page_and_copy(original, copy)
    assert_not_nil original
    assert_not_nil copy

    assert original.title == copy.title
    assert original.name == copy.name
    assert original.position == copy.position
    assert original.estimated_time == copy.estimated_time
    assert original.page_type == copy.page_type
    assert original.description == copy.description
    assert_not_nil copy.original
    assert original.id == copy.original.id
    assert_equal copy.owner_id, copy.az_base_project.owner_id

    if original.design_source != nil
      assert_not_nil copy.design_source
      assert_not_equal original.design_source.id, copy.design_source.id
      assert_equal original.design_source.id, copy.design_source.original.id
    end

    if original.functionality_source != nil
      assert_not_nil copy.functionality_source
      assert_not_equal original.functionality_source.id, copy.functionality_source.id
      assert_equal original.functionality_source.id, copy.functionality_source.original.id
    end

    original_designs = original.az_designs
    copied_designs_by_original = get_copies_by_original(AzDesign, original_designs)
    copied_designs_by_original.each_pair do |design_o, designs_c|
      assert_not_nil designs_c
      assert designs_c.size > 0
      designs_c.each do |design_c|
        compare_design_and_copy(design_o, design_c)
      end
    end

    original_typed_pages = original.az_typed_pages
    copied_typed_pages_by_original = get_copies_by_original(AzTypedPage, original_typed_pages)
    
    #assert_equal original.az_typed_pages.size, copied_typed_pages_by_original[original].size

    copied_typed_pages_by_original.each_pair do |typed_page_o, typed_pages_c|
      assert_not_nil typed_pages_c
      assert typed_pages_c.size > 0
      typed_pages_c.each do |typed_page_c|
        compare_typed_page_and_copy(typed_page_o, typed_page_c)
      end
    end

    copied_children_by_original = get_copies_by_original(AzPage, original.children)

    copied_children_by_original.each_pair do |child_o, children_c|
      children_c.each do |child_c|
        compare_page_and_copy(child_o, child_c)
      end
    end

  end


end
