ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'
require 'az_design_source_test_helper'
require 'declarative_authorization/maintenance'

class ActiveSupport::TestCase
  
  def logger
    RAILS_DEFAULT_LOGGER
  end

  def create_design(user, owner, description, page)
    Authorization.current_user = user
    design = AzDesign.new
    design.owner = owner
    design.az_page = page
    design.description = description

    unless design.save
      logger.error(show_errors(design.errors))
      return nil
    end
    return design
  end

  def compare_design_and_copy(original, copy)
    assert_not_nil original
    assert_not_nil copy
    assert_equal original.id, copy.copy_of
    assert_equal original.az_page.id, copy.az_page.copy_of
    assert_equal original.description, copy.description

    original_images = original.az_images
    copied_images_by_original = get_copies_by_original(AzImage, original_images)

    copied_images_by_original.each_pair do |original_img, copies|
      assert_not_nil copies
      assert copies.size > 0
      copies.each do |copy_img|
        compare_image_and_copy(original_img, copy_img)
      end
    end

    original_source = original.az_design_source
    copied_source = copy.az_design_source

    compare_source_and_copy(original_source, copied_source)

  end

end
