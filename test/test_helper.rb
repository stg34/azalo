ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'
require 'declarative_authorization/maintenance'
require 'az_tariff_test_helper'

class ActiveSupport::TestCase
  # Transactional fixtures accelerate your tests by wrapping each test method
  # in a transaction that's rolled back on completion.  This ensures that the
  # test database remains unchanged so your fixtures don't have to be reloaded
  # between every test method.  Fewer database queries means faster tests.
  #
  # Read Mike Clark's excellent walkthrough at
  #   http://clarkware.com/cgi/blosxom/2005/10/24#Rails10FastTesting
  #
  # Every Active Record database supports transactions except MyISAM tables
  # in MySQL.  Turn off transactional fixtures in this case; however, if you
  # don't care one way or the other, switching from MyISAM to InnoDB tables
  # is recommended.
  #
  # The only drawback to using transactional fixtures is when you actually 
  # need to test transactions.  Since your test is bracketed by a transaction,
  # any transactions started in your code will be automatically rolled back.
  #self.use_transactional_fixtures = true

  # Instantiated fixtures are slow, but give you @david where otherwise you
  # would need people(:david).  If you don't want to migrate your existing
  # test cases which use the @david style and don't mind the speed hit (each
  # instantiated fixtures translates to a database query per test method),
  # then set this back to true.
  #self.use_instantiated_fixtures  = false

  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  #fixtures :all

  # Add more helper methods to be used by all tests here...

  def logger
    RAILS_DEFAULT_LOGGER
  end

  def show_errors(errors)
    str = ""
    if errors.size > 0
      str += "==================================================================\n"
      str += "   ERROR   \n"
      errors.each{|attr,msg| str += "#{attr} - #{msg}\n" }
      str += "==================================================================\n"
    end
    return str
  end

  def prepare_az_rm_roles

    role_names = ['Менеджер', 'Программист', 'Тестировщик']
    az_rm_roles = []

    role_names.each do |rn|
      az_rm_role = AzRmRole.new
      az_rm_role.name = rn
      az_rm_role.rm_role_id = az_rm_role.id

      if az_rm_role.save
        az_rm_roles << az_rm_role
      end
    end

    if az_rm_roles.size == role_names.size
      return az_rm_roles
    else
      return nil
    end
  end


  def prepare_user(role)
    #AzUser.set_registration_open(true)
    usr = AzUser.new
    usr.roles = [role]
    usr.login = "fafa_#{rand(1000)}"
    usr.name = 'fafa'
    usr.lastname = 'kuku'
    usr.email = "fafa_#{rand(1000)}@example.com"
    usr.password = 'fafa-kuku'
    usr.password_confirmation = usr.password

    if usr.save
      logger.info 'User created successfully'
      return usr
    else
      logger.error 'User not created!'
      logger.error(show_errors(usr.errors))
      return nil
    end
  end

  def prepare_company(user)
    tariff = prepare_tariff('tariff name', 10, 100, 100)

    cmp = AzCompany.new
    cmp.ceo = user
    cmp.name = 'cmp_' + user.login
    cmp.az_tariff = tariff
    cmp.save
    if cmp.save
      return cmp
    else
      return nil
    end
  end

  
#  def prepare_variable(user, owner, name, type)
#    Authorization.current_user = user
#    var = AzVariable.new
#    var.name = name
#    var.owner = owner
#    var.az_base_data_type = type
#
#    if var.save
#      return var
#    else
#      return nil
#    end
#  end

  def is_table_size_equal?(model, s)
    return model.all.size == s
  end

  def table_size(model)
    model.all.size
  end

  def get_test_files_dir
    return File.expand_path(File.dirname(__FILE__) + "/test_files/")
  end

  def get_copies_by_original(item_class, items_orig = nil)
    if items_orig == nil
      items_orig = item_class.find(:all, :conditions => {:copy_of => nil})
    end

    items = {}
    items_orig.each do |i|
      items[i] = item_class.find(:all, :conditions => {:copy_of => i.id})
    end
    return items
  end

end
