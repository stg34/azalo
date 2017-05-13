ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_helper'
require 'declarative_authorization/maintenance'

class ActiveSupport::TestCase
  
  def logger
    Rails.logger
  end

  def create_image(user, owner, design, image_file)
    Authorization.current_user = user
    img = AzImage.new
    img.owner = owner
    img.az_design = design
    img.image = image_file

    unless img.save
      logger.error(show_errors(img.errors))
      return nil
    end
    return img
  end

  def get_correct_image_files
    return get_image_files(['image_300x200.png', 'image_300x200.jpg', 'image_300x200.jpeg', 'image_300x200.gif'])
  end

  def get_incorrect_image_files
    return get_image_files(['image_300x200.bmp', 'image_300x200.tif'])
  end

  def compare_image_and_copy(original, copy)
    assert_not_nil original
    assert_not_nil copy
    assert_equal original.id, copy.copy_of
    assert_equal copy.az_design.owner_id, copy.owner_id
    assert_equal original.az_design.id, copy.az_design.copy_of

    #puts original.inspect
    #puts copy.inspect
    original.image.styles.each_pair do |k, v|
      file_name_o = File.expand_path(original.image.path(k))
      file_name_c = File.expand_path(copy.image.path(k))

      #puts file_name_o
      #puts file_name_c

      assert file_name_o != file_name_c
      assert File.basename(file_name_o) == File.basename(file_name_c)
      assert File.exist?(file_name_c)
      assert File.size(file_name_c) == File.size(file_name_o)
    end
  end

  def get_image_files(file_names)
    tmp_dir_name = Dir.mktmpdir
    FileUtils.makedirs(tmp_dir_name)

    rnd_str = rand(10000).to_s + '_'

    file_names.each do |fn|
      FileUtils.copy(get_test_files_dir + File::Separator + fn, tmp_dir_name + File::Separator + rnd_str + fn)
    end

    files = file_names.collect { |fn| File.new(tmp_dir_name + File::Separator + rnd_str + fn, "r") }
    return files
  end

end
