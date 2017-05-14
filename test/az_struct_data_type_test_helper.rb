ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'
require 'declarative_authorization/maintenance'

class ActiveSupport::TestCase
  
  def logger
    RAILS_DEFAULT_LOGGER
  end

  def create_struct_with_variables(user, company, project)
    # Структура_1
    # |---Переменная_1 : Простой_тип_1
    # |---Переменная_2 : Структура_2
    # |                  |--- Переменная_2_1 : Структура_1
    # |---Переменная_3 : Коллекция<Структура_3>
    # |                  |--- Переменная_3_1 : Простой_тип_2
    # |---Переменная_4 : Коллекция<Структура_1>

    simple_types = prepare_simple_data_types(user, company)
    assert_not_nil simple_types

    struct_1 = create_struct_data_type(user, company, 'struct_1', project)
    assert_not_nil struct_1

    struct_2 = create_struct_data_type(user, company, 'struct_2', project)
    assert_not_nil struct_2

    struct_3 = create_struct_data_type(user, company, 'struct_3', project)
    assert_not_nil struct_3

    list_tpl = create_collection_template(user, company, 'list')
    assert_not_nil list_tpl

    struct_1_list = create_collection_data_type(user, company, 'list_of_struct_1', list_tpl, struct_1, project)
    assert_not_nil struct_1_list

    struct_3_list = create_collection_data_type(user, company, 'list_of_struct_3', list_tpl, struct_3, project)
    assert_not_nil struct_3_list

    vars = {}

    # Переменная_1 : Простой_тип_1
    var_name = "var_1_simple_type"
    vars[var_name] = create_variable(user, company, struct_1, simple_types[rand(simple_types.size)], var_name)
    assert_not_nil vars[var_name]

    create_validator(user, company, 'validator-name-1', 'validator-description-1', 'validator-message-1', 'validator-condition-1', vars[var_name])

    # Переменная_2 : Структура_2
    var_name = "var_2_struct_2"
    vars[var_name] = create_variable(user, company, struct_1, struct_2, var_name)
    assert_not_nil vars[var_name]

    create_validator(user, company, 'validator-name-2', 'validator-description-2', 'validator-message-2', 'validator-condition-2', vars[var_name])

    # Переменная_3 : Коллекция<Структура_3>
    var_name = "var_3_struct_3_list"
    vars[var_name] = create_variable(user, company, struct_1, struct_3_list, var_name)
    assert_not_nil vars[var_name]

    # Переменная_4 : Коллекция<Структура_1>
    var_name = "var_4_struct_1_list"
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

    return struct_1
  end

  def create_struct_data_type(user, owner, name, project, seed = nil)
    Authorization.current_user = user
    dt = AzStructDataType.new
    dt.name = name
    dt.owner = owner
    dt.az_base_project = project
    if seed != nil
      dt.seed = seed
    end

    unless dt.save
      logger.error(show_errors(dt.errors))
      return nil
    end
    return dt
  end

  def compare_struct_data_type_and_copy(original, copy, copied_struct_ids = {}, compared_struct_ids = [])

    if compared_struct_ids.include?(copy.id)
      return
    end
    compared_struct_ids << copy.id

    copied_struct_ids[original.id] = copy.id

    assert_equal original.az_variables.size, copy.az_variables.size
    assert_equal original.name, copy.name
    assert_equal original.type, copy.type
    assert_equal original.az_base_data_type_id, copy.az_base_data_type_id
    assert_nil original.az_collection_template_id
    assert_equal original.az_collection_template_id, copy.az_collection_template_id
    assert_equal original.description, copy.description
    assert_equal original.id, copy.copy_of

    if original.az_base_project
      assert_equal copy.az_base_project.owner_id, copy.owner_id
    end

    vos = {}
    vcs = {}

    original.az_variables.map do |v| 
      vos[v.id] = v
    end


    copy.az_variables.map do |v| 
      assert_not_nil v.copy_of
      vcs[v.copy_of] = v
    end

    original.az_variables.each do |vo|
      copy = vcs[vo.id]
      compare_variable_and_copy(vo, copy)
      
      # Если структура рекурсивная, т.е. в ней есть переменные или коллекции того же типа, что и сама структура, 
      # то нужно проверить, что эта переменная есть ссылка на уже созданную структуру, а не еще одна копия структруры
      # т.е. оригинал: struct_1 <-- var_1:struct_1
      # то копия не должна быть: struct_1` <-- var_1`:struct_2`, где struct_1` и struct_2` две копии оригинальной struct_1
       
      if vo.az_base_data_type.class == AzStructDataType
        if copied_struct_ids[vcs[vo.id].az_base_data_type.id]
          assert_equal copied_struct_ids[vo.az_base_data_type.id], copied_struct_ids[vcs[vo.id]]
        else
          copied_struct_ids[vo.az_base_data_type.id] = copied_struct_ids[vcs[vo.id]]
        end

        compare_struct_data_type_and_copy(vo.az_base_data_type, vcs[vo.id].az_base_data_type, copied_struct_ids, compared_struct_ids)
      end
    end

    

  end

end
