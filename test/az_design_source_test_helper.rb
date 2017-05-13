ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_helper'
require 'declarative_authorization/maintenance'

class ActiveSupport::TestCase
  
  def logger
    Rails.logger
  end

  def create_design_source(user, owner, design, source_file)
    Authorization.current_user = user
    ds = AzDesignSource.new
    ds.owner = owner
    ds.az_design = design
    ds.source = source_file

    ds.save!

    return ds
  end

  def get_correct_source_files
    return get_source_files(["pencil_1.ep", "pencil_2.ep", "photoshop_1.psd"])
  end

  def get_incorrect_source_files
    return get_source_files(["_pencil_1.ep", "_pencil_2.ep", "_photoshop_1.psd"])
  end

  def compare_source_and_copy(original, copy)
    if original == nil && copy == nil
      return
    end
    assert_not_nil original
    assert_not_nil copy
    assert_equal original.id, copy.copy_of
    assert_equal copy.az_design.owner_id, copy.owner_id
    assert_equal original.az_design.id, copy.az_design.copy_of

    original.source.styles.each_pair do |k, v|
      file_name_o = File.expand_path(original.source.path(k))
      file_name_c = File.expand_path(copy.source.path(k))

      assert file_name_o != file_name_c
      assert File.basename(file_name_o) == File.basename(file_name_c)
      assert File.exist?(file_name_c)
      assert File.size(file_name_c) == File.size(file_name_o)
    end
  end

  def get_source_files(file_names)
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
