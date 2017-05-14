require 'test_helper'
require 'az_variable_test_helper'
require 'az_simple_data_type_test_helper'
require 'az_struct_data_type_test_helper'
require 'az_collection_template_test_helper'
require 'az_collection_data_type_test_helper'
require 'az_project_test_helper'

class AzStructDataTypeTest < ActiveSupport::TestCase
  fixtures :az_base_data_types

  # ---------------------------------------------------------------------------
  test "Create correct AzStructDataType" do
    Authorization.current_user = nil

    assert is_table_size_equal?(AzStructDataType, 0)

    user = prepare_user(:user)
    assert_not_nil user

    company = prepare_company(user)
    assert_not_nil company

    
    project = create_project(user, company, 'project')
    assert_not_nil project

    assert_not_nil create_struct_data_type(user, company, 'struct', project)

    assert is_table_size_equal?(AzStructDataType, 1)
  end
  # ---------------------------------------------------------------------------
  test "Create correct AzStructDataType with variables" do
    Authorization.current_user = nil

    assert is_table_size_equal?(AzStructDataType, 0)

    user = prepare_user(:user)
    assert_not_nil user

    company = prepare_company(user)
    assert_not_nil company

    project = create_project(user, company, 'project')
    assert_not_nil project

    simple_types = prepare_simple_data_types(user, company)
    assert_not_nil simple_types
    
    sdt = create_struct_data_type(user, company, 'struct', project)
    assert_not_nil sdt

    assert is_table_size_equal?(AzVariable, 0)

    var_list = []
    var_num_1 = 5
    (1..var_num_1).each do
      var = create_variable(user, company, sdt, simple_types[rand(simple_types.size)], "var_name_#{rand(10000)}")
      assert_not_nil var
      var_list << var
    end

    assert sdt.az_variables.size == var_num_1

    assert is_table_size_equal?(AzVariable, var_num_1)

    assert is_table_size_equal?(AzStructDataType, 1)
  end
  # ---------------------------------------------------------------------------
  test "Create incorrect AzStructDataType" do
    Authorization.current_user = nil

    assert is_table_size_equal?(AzStructDataType, 0)

    user = prepare_user(:user)
    assert_not_nil user

    company = prepare_company(user)
    assert_not_nil company

    project = create_project(user, company, 'project')
    assert_not_nil project

    assert_nil create_struct_data_type(user, company, '', project)
    assert_nil create_struct_data_type(user, company, nil, project)
    #assert_nil create_struct_data_type(user, company, 'fafa', nil) # структура не может быть не связана с проектом. 

    assert is_table_size_equal?(AzStructDataType, 0)
  end

  test "AzStructDataType.make_copy() 1" do
    # Копируем простую структуру данных:
    # Структура_1
    # |---Переменная_1 : Простой_тип_1
    # |---Переменная_2 : Простой_тип_2
    # |---Переменная_3 : Простой_тип_3

    Authorization.current_user = nil

    user = prepare_user(:user)
    assert_not_nil user

    company = prepare_company(user)
    assert_not_nil company

    project = create_project(user, company, 'project')
    assert_not_nil project

    assert is_table_size_equal?(AzSimpleDataType, 0)
    assert is_table_size_equal?(AzVariable, 0)
    assert is_table_size_equal?(AzStructDataType, 0)

    simple_types = prepare_simple_data_types(user, company)
    assert_not_nil simple_types

    sdt = create_struct_data_type(user, company, 'struct', project)
    assert_not_nil sdt

    var_list = []
    var_num_1 = 5
    (1..var_num_1).each do
      var = create_variable(user, company, sdt, simple_types[rand(simple_types.size)], "var_name_#{rand(10000)}")
      assert_not_nil var
      var_list << var
    end

    assert is_table_size_equal?(AzSimpleDataType, simple_types.size)
    assert is_table_size_equal?(AzVariable, var_num_1)
    assert is_table_size_equal?(AzStructDataType, 1)

    assert sdt.az_variables.size == var_num_1

    #project = nil
    sdt1 = sdt.make_copy_data_type(company, project)

    assert sdt1.id != sdt.id
    assert sdt1.copy_of == sdt.id
    assert sdt1.az_variables.size == var_num_1

    copied_vars = AzVariable.find(:all, :conditions => [' copy_of IS NOT NULL '])
    assert copied_vars.size == var_num_1
    copied_vars.each do |c_var|
      o_var = AzVariable.find(c_var.copy_of)
      #puts orig_var.inspect
      #puts cvar.inspect
      assert o_var.name == c_var.name
      assert o_var.az_base_data_type_id == c_var.az_base_data_type_id
    end

    assert is_table_size_equal?(AzSimpleDataType, simple_types.size)
    assert is_table_size_equal?(AzVariable, var_num_1 * 2)
    assert is_table_size_equal?(AzStructDataType, 2)

  end
  # ---------------------------------------------------------------------------
  test "AzStructDataType.make_copy() 2" do
    # Копируем структуру данных с коллекцией внутри одного проекта:
    # Структура_1
    # |---Переменная_1 : Простой_тип_1
    # |---Переменная_2 : Коллекция<Простой_тип_2>

    Authorization.current_user = nil

    user = prepare_user(:user)
    assert_not_nil user

    company = prepare_company(user)
    assert_not_nil company

    project = create_project(user, company, 'project')
    assert_not_nil project

    test_AzStructDataType_make_copy_1(user, company, project, project)

  end
  # ---------------------------------------------------------------------------
  test "AzStructDataType.make_copy() 3" do
    # Копируем структуру данных с коллекцией между проектами:
    # Структура_1
    # |---Переменная_1 : Простой_тип_1
    # |---Переменная_2 : Коллекция<Простой_тип_2>

    Authorization.current_user = nil

    user = prepare_user(:user)
    assert_not_nil user

    company = prepare_company(user)
    assert_not_nil company

    project_src = create_project(user, company, 'project_src')
    assert_not_nil project_src

    project_dst = create_project(user, company, 'project_dst')
    assert_not_nil project_dst

    test_AzStructDataType_make_copy_1(user, company, project_src, project_dst)

  end
  # ---------------------------------------------------------------------------
  test "AzStructDataType.make_copy() 4" do
    # Копируем структуру данных с рекурсией внутри одного проекта:

    Authorization.current_user = nil

    user = prepare_user(:user)
    assert_not_nil user

    company = prepare_company(user)
    assert_not_nil company

    project_src = create_project(user, company, 'project_src')
    assert_not_nil project_src

    project_dst = create_project(user, company, 'project_dst')
    assert_not_nil project_dst

    test_AzStructDataType_make_copy_2(user, company, project_src, project_src)

  end
  # ---------------------------------------------------------------------------
  test "AzStructDataType.make_copy() 5" do
    # Копируем структуру данных с рекурсией внутри одного проекта:

    Authorization.current_user = nil

    user = prepare_user(:user)
    assert_not_nil user

    company = prepare_company(user)
    assert_not_nil company

    project_src = create_project(user, company, 'project_src')
    assert_not_nil project_src

    project_dst = create_project(user, company, 'project_dst')
    assert_not_nil project_dst

    test_AzStructDataType_make_copy_2(user, company, project_src, project_dst)

  end
  # ---------------------------------------------------------------------------
  test "AzStructDataType reset seed test" do
    Authorization.current_user = nil

    assert is_table_size_equal?(AzStructDataType, 0)

    user = prepare_user(:user)
    assert_not_nil user

    company = prepare_company(user)
    assert_not_nil company


    project = create_project(user, company, 'project')
    assert_not_nil project

    str = create_struct_data_type(user, company, 'struct', project, true)
    assert_not_nil str

    assert str.seed == true
    assert is_table_size_equal?(AzStructDataType, 1)
    assert AzStructDataType.get_seeds.size == 1
    
    str_c = str.make_copy_data_type(company, project)

    assert str_c.seed == false
    assert is_table_size_equal?(AzStructDataType, 2)
    assert AzStructDataType.get_seeds.size == 1
  end
  # ---------------------------------------------------------------------------

  private
  def test_AzStructDataType_make_copy_1(user, company, project_src, project_dst)
    # Копируем структуру данных с коллекцией:
    # Структура_1
    # |---Переменная_1 : Простой_тип_1
    # |---Переменная_2 : Коллекция<Простой_тип_2>

    assert is_table_size_equal?(AzSimpleDataType, 0)
    assert is_table_size_equal?(AzVariable, 0)
    assert is_table_size_equal?(AzStructDataType, 0)
    assert is_table_size_equal?(AzCollectionDataType, 0)
    assert is_table_size_equal?(AzCollectionTemplate, 0)

    simple_types = prepare_simple_data_types(user, company)
    assert_not_nil simple_types

    sdt = create_struct_data_type(user, company, 'struct', project_src)
    assert_not_nil sdt

    ctpl = create_collection_template(user, company, 'list')
    assert_not_nil ctpl

    cdt = create_collection_data_type(user, company, 'list_of_foo', ctpl, simple_types[rand(simple_types.size)], project_src)
    assert_not_nil cdt

    var1 = create_variable(user, company, sdt, simple_types[rand(simple_types.size)], "var_name_1")
    assert_not_nil var1

    var2 = create_variable(user, company, sdt, cdt, "var_name_2")
    assert_not_nil var2

    assert is_table_size_equal?(AzSimpleDataType, simple_types.size)
    assert is_table_size_equal?(AzVariable, 2)
    assert is_table_size_equal?(AzStructDataType, 1)
    assert is_table_size_equal?(AzCollectionDataType, 1)
    assert is_table_size_equal?(AzCollectionTemplate, 1)

    assert sdt.az_variables.size == 2

    sdt1 = sdt.make_copy_data_type(company, project_dst)

    assert sdt1.id != sdt.id
    assert sdt1.copy_of == sdt.id
    assert sdt1.az_variables.size == 2
    assert sdt1.az_base_project.id == project_dst.id

    copied_vars = AzVariable.find(:all, :conditions => [' copy_of IS NOT NULL '])
    assert copied_vars.size == 2
    copied_vars.each do |c_var|
      o_var = AzVariable.find(c_var.copy_of)
      #puts o_var.inspect
      #puts c_var.inspect
      assert o_var.name == c_var.name

      if o_var.az_base_data_type.class == AzSimpleDataType
        # Если простой тип, то он не меняется
        assert o_var.az_base_data_type_id == c_var.az_base_data_type_id
      elsif o_var.az_base_data_type.class == AzCollectionDataType
        # Если тип - массив, то он меняется, но его тип данных, если он простой не меняется.
        assert o_var.az_base_data_type.az_base_data_type.id == c_var.az_base_data_type.az_base_data_type.id
        assert o_var.az_base_data_type.id == c_var.az_base_data_type.copy_of

        # Скопрированная переменная должна иметь тип, который принадлежит project_dst
        assert c_var.az_base_data_type.az_base_project.id == project_dst.id
      end
    end

    assert is_table_size_equal?(AzSimpleDataType, simple_types.size)
    assert is_table_size_equal?(AzVariable, 2 * 2)
    assert is_table_size_equal?(AzStructDataType, 2)
    assert is_table_size_equal?(AzCollectionDataType, 2)
    assert is_table_size_equal?(AzCollectionTemplate, 1)

  end


  def test_AzStructDataType_make_copy_2(user, company, project_src, project_dst)
    # Копируем структуру данных с рекурсией:
    # Структура_1
    # |---Переменная_1 : Простой_тип_1
    # |---Переменная_2 : Структура_2
    # |                  |--- Переменная_2_1 : Структура_1
    # |---Переменная_3 : Коллекция<Структура_3>
    # |                  |--- Переменная_3_1 : Простой_тип_2
    # |---Переменная_4 : Коллекция<Структура_1>

    assert is_table_size_equal?(AzSimpleDataType, 0)
    assert is_table_size_equal?(AzVariable, 0)
    assert is_table_size_equal?(AzStructDataType, 0)
    assert is_table_size_equal?(AzCollectionDataType, 0)
    assert is_table_size_equal?(AzCollectionTemplate, 0)

    simple_types = prepare_simple_data_types(user, company)
    assert_not_nil simple_types

    struct_1 = create_struct_data_type(user, company, 'struct_1', project_src)
    assert_not_nil struct_1

    struct_2 = create_struct_data_type(user, company, 'struct_2', project_src)
    assert_not_nil struct_2

    struct_3 = create_struct_data_type(user, company, 'struct_3', project_src)
    assert_not_nil struct_3

    list_tpl = create_collection_template(user, company, 'list')
    assert_not_nil list_tpl

    struct_1_list = create_collection_data_type(user, company, 'list_of_struct_1', list_tpl, struct_1, project_src)
    assert_not_nil struct_1_list

    struct_3_list = create_collection_data_type(user, company, 'list_of_struct_3', list_tpl, struct_3, project_src)
    assert_not_nil struct_3_list

    vars = {}

    # Переменная_1 : Простой_тип_1
    var_name = "var_name_1"
    vars[var_name] = create_variable(user, company, struct_1, simple_types[rand(simple_types.size)], var_name)
    assert_not_nil vars[var_name]

    # Переменная_2 : Структура_2
    var_name = "var_name_2"
    vars[var_name] = create_variable(user, company, struct_1, struct_2, var_name)
    assert_not_nil vars[var_name]

    # Переменная_3 : Коллекция<Структура_3>
    var_name = "var_name_3"
    vars[var_name] = create_variable(user, company, struct_1, struct_3_list, var_name)
    assert_not_nil vars[var_name]

    # Переменная_4 : Коллекция<Структура_1>
    var_name = "var_name_4"
    vars[var_name] = create_variable(user, company, struct_1, struct_1_list, var_name)
    assert_not_nil vars[var_name]

    # Переменная_2_1 : Структура_1
    var_name = "var_name_2_1"
    vars[var_name] = create_variable(user, company, struct_2, struct_1, var_name)
    assert_not_nil vars[var_name]

    # Переменная_3_1 : Простой_тип_2
    var_name = "var_name_3_1"
    vars[var_name] = create_variable(user, company, struct_3, simple_types[rand(simple_types.size)], var_name)
    assert_not_nil vars[var_name]

#    puts '----------------------------------------------------'
#    puts struct_1.inspect
#    struct_1.az_variables.each do |v|
#      puts "  " + v.inspect
#      puts "    " + v.az_base_data_type.inspect
#    end
#    puts '----------------------------------------------------'
#    puts struct_2.inspect
#    struct_2.az_variables.each do |v|
#      puts "  " + v.inspect
#      puts "    " + v.az_base_data_type.inspect
#    end
#    puts '----------------------------------------------------'
#    puts struct_3.inspect
#    struct_3.az_variables.each do |v|
#      puts "  " + v.inspect
#      puts "    " + v.az_base_data_type.inspect
#    end
#    puts '----------------------------------------------------'

    assert is_table_size_equal?(AzSimpleDataType, simple_types.size)
    assert is_table_size_equal?(AzVariable, 6)
    assert is_table_size_equal?(AzStructDataType, 3)
    assert is_table_size_equal?(AzCollectionDataType, 2)
    assert is_table_size_equal?(AzCollectionTemplate, 1)

    assert struct_1.az_variables.size == 4
    assert struct_2.az_variables.size == 1
    assert struct_3.az_variables.size == 1

    struct_1_c = struct_1.make_copy_data_type(company, project_dst)
    struct_2_c = AzStructDataType.find(:first, :conditions => {:copy_of => struct_2.id})
    struct_3_c = AzStructDataType.find(:first, :conditions => {:copy_of => struct_3.id})

    assert struct_1_c.name == struct_1.name
    assert struct_2_c.name == struct_2.name
    assert struct_3_c.name == struct_3.name

    assert struct_1_c.az_variables.size == 4
    assert struct_2_c.az_variables.size == 1
    assert struct_3_c.az_variables.size == 1

    vars_c = {}
    vars_c['var_name_1'] = AzVariable.find(:first, :conditions => {:copy_of => vars['var_name_1'].id})
    vars_c['var_name_2'] = AzVariable.find(:first, :conditions => {:copy_of => vars['var_name_2'].id})
    vars_c['var_name_3'] = AzVariable.find(:first, :conditions => {:copy_of => vars['var_name_3'].id})
    vars_c['var_name_4'] = AzVariable.find(:first, :conditions => {:copy_of => vars['var_name_4'].id})
    vars_c['var_name_2_1'] = AzVariable.find(:first, :conditions => {:copy_of => vars['var_name_2_1'].id})
    vars_c['var_name_3_1'] = AzVariable.find(:first, :conditions => {:copy_of => vars['var_name_3_1'].id})

    vars.each_pair do |key, value|
      var_o = value
      var_c = vars_c[key]
      assert_not_nil var_c
      
      assert var_o.name == var_c.name
      if var_o.az_base_data_type.class == AzSimpleDataType
        assert var_o.az_base_data_type.id == var_c.az_base_data_type.id
      elsif var_o.az_base_data_type.class == AzCollectionDataType || var_o.az_base_data_type.class == AzStructDataType
        assert var_o.az_base_data_type.id == var_c.az_base_data_type.copy_of
        assert var_o.az_base_data_type.id != var_c.az_base_data_type.id
        # Скопрированная переменная должна иметь тип, который принадлежит project_dst
        assert var_c.az_base_data_type.az_base_project.id == project_dst.id
      end
    end

    assert is_table_size_equal?(AzSimpleDataType, simple_types.size)
    assert is_table_size_equal?(AzVariable, 6 * 2)
    assert is_table_size_equal?(AzStructDataType, 3 * 2)
    assert is_table_size_equal?(AzCollectionDataType, 2 * 2)
    assert is_table_size_equal?(AzCollectionTemplate, 1)

  end


end
