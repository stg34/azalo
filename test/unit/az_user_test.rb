require 'test_helper'
require 'az_user_test_helper'

class AzTaskTest < ActiveSupport::TestCase

  # ---------------------------------------------------------------------------
  test 'Create correct AzUser' do

    clear_az_db
    Authorization.current_user = nil
    
    #AzUser.set_registration_open(true)

    assert is_table_size_equal?(AzUser, 0)

    user = AzUser.new
    user.login = "login"
    user.name = "name"
    user.lastname = "lastname"
    user.email = "werty@example.com"
    user.password = "1234567890"
    user.password_confirmation = user.password
    user.never_visited = true
    user.roles = [:user]
    #user.hash_str = params[:az_user][:hash_str]
    success = user.save

    assert success

    unless success
      logger.error(show_errors(user.errors))
    end

    assert is_table_size_equal?(AzUser, 1)
  end
  # ---------------------------------------------------------------------------
  test 'Create user with too short password' do
    clear_az_db
    Authorization.current_user = nil

    #AzUser.set_registration_open(true)

    assert is_table_size_equal?(AzUser, 0)

    user = AzUser.new
    user.login = "login"
    user.name = "name"
    user.lastname = "lastname"
    user.email = "werty@example.com"
    user.password = "12345"
    user.password_confirmation = user.password
    user.never_visited = true
    user.roles = [:user]
    #user.hash_str = params[:az_user][:hash_str]
    success = user.save

    assert !success

    unless success
      logger.error(show_errors(user.errors))
    end

    user.password = nil
    user.password_confirmation = user.password

    assert !success

    unless success
      logger.error(show_errors(user.errors))
    end

    assert is_table_size_equal?(AzUser, 0)
  end
  # ---------------------------------------------------------------------------
  test 'Create and update correct AzUser' do
    clear_az_db
    Authorization.current_user = nil

    #AzUser.set_registration_open(true)

    assert is_table_size_equal?(AzUser, 0)

    user = AzUser.new
    user.login = "login"
    user.name = "name"
    user.lastname = "lastname"
    user.email = "werty@example.com"
    user.password = "1234567890"
    user.password_confirmation = user.password
    user.never_visited = true
    user.roles = [:user]

    success = user.save

    assert success

    unless success
      logger.error(show_errors(user.errors))
    end

    user1 = AzUser.find(user.id)

    user1.disabled = false
    success = user1.save

    assert success

    unless success
      logger.error(show_errors(user1.errors))
    end

    assert is_table_size_equal?(AzUser, 1)
  end
  # ---------------------------------------------------------------------------
  test 'Create user and update password' do
    clear_az_db
    Authorization.current_user = nil

    #AzUser.set_registration_open(true)

    assert is_table_size_equal?(AzUser, 0)

    user = AzUser.new
    user.login = "login"
    user.name = "name"
    user.lastname = "lastname"
    user.email = "werty@example.com"
    user.password = "1234567890"
    user.password_confirmation = user.password
    user.never_visited = true
    user.roles = [:user]
    #user.hash_str = params[:az_user][:hash_str]
    success = user.save


    unless success
      logger.error(show_errors(user.errors))
    end

    user_old_pass = AzUser.find(user.id)
    old_cr_pass = user_old_pass.crypted_password

    user.new_password = '0987654321'
    user.new_password_confirmation = '0987654321'
    user.old_password = "1234567890"
    user.password = user.new_password
    user.password_confirmation = user.new_password_confirmation
    success = user.save

    user_new_pass = AzUser.find(user.id)
    new_cr_pass = user_new_pass.crypted_password

    assert success
    unless success
      logger.error(show_errors(user.errors))
    end

    assert old_cr_pass != new_cr_pass

    user.new_password = '0000000'
    user.new_password_confirmation = '0987654321'
    user.old_password = "1234567890"
    success = user.save
    assert !success
    unless success
      logger.error(show_errors(user.errors))
    end

    user.new_password = '0987654321'
    user.new_password_confirmation = '0000000'
    user.old_password = "1234567890"
    success = user.save
    assert !success
    unless success
      logger.error(show_errors(user.errors))
    end

    user.new_password = '0987654321'
    user.new_password_confirmation = '0987654321'
    user.old_password = "00000"
    success = user.save
    assert !success
    unless success
      logger.error(show_errors(user.errors))
    end



    assert is_table_size_equal?(AzUser, 1)
  end
  # ---------------------------------------------------------------------------
  test 'Set password to nil' do
    clear_az_db
    Authorization.current_user = nil

    #AzUser.set_registration_open(true)

    assert is_table_size_equal?(AzUser, 0)

    user = AzUser.new
    user.login = "login"
    user.name = "name"
    user.lastname = "lastname"
    user.email = "werty@example.com"
    user.password = "1234567890"
    user.password_confirmation = user.password
    user.never_visited = true
    user.roles = [:user]
    #user.hash_str = params[:az_user][:hash_str]
    success = user.save


    unless success
      logger.error(show_errors(user.errors))
    end

    user_old_pass = AzUser.find(user.id)
    old_cr_pass = user_old_pass.crypted_password

    user.new_password = nil
    user.new_password_confirmation = nil
    user.old_password = nil
    user.password = user.new_password
    user.password_confirmation = user.new_password_confirmation
    success = user.save

    user_new_pass = AzUser.find(user.id)
    new_cr_pass = user_new_pass.crypted_password

    assert success
    unless success
      logger.error(show_errors(user.errors))
    end

    assert old_cr_pass == new_cr_pass

    assert is_table_size_equal?(AzUser, 1)
  end
  # ---------------------------------------------------------------------------
end
