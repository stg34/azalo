require 'rubygems'
require 'timecop'
require 'test_helper'
require 'az_project_test_helper'
require 'az_project_block_test_helper'
require 'az_definition_test_helper'
require 'az_validator_test_helper'
require 'az_simple_data_type_test_helper'
require 'az_struct_data_type_test_helper'
require 'az_variable_test_helper'
require 'az_common_test_helper'
require 'az_tariff_test_helper'
require 'az_company_test_helper'
require 'az_project_status_test_helper'

class AzCompanyTest2 < ActiveSupport::TestCase

 test "AzCompany ceo not disabled" do

    Authorization.current_user = nil
    user = prepare_user(:user)

    free_tariff = prepare_free_tariff('free')
    assert_not_nil free_tariff

    # Создали компанию, uesr - CEO
    company = prepare_company_1(user, free_tariff)
    assert_not_nil company

    # Перегружаем компанию, для обновления ассоциаций
    #company.reload

    # Сотрудников в компании 1шт - CEO, все активны
    assert_equal 1, company.az_employees.size
    assert_equal 1, company.enabled_employees.size
    assert_equal company.enabled_employees.size, company.az_employees.size
    assert company.employee_quota_reached

    # Пробуем задизэйблить директора, ожидаем, что ничего не получилось
    assert company.az_employees[0].disable == false

    # Сотрудников в компании 1шт - CEO, все активны по прежнему
    #company.reload
    assert_equal 1, company.az_employees.size
    assert_equal 1, company.enabled_employees.size
  end

  test "AzCompany employee quota test 1" do

    Authorization.current_user = nil
    user = prepare_user(:user)
    employee = prepare_user(:user)

    # Создаем бесплатный тариф с нулевой квотой на сотрудников. Нулевая квота означает, что у комапиии может быть 0 сотрудников, КРОМЕ директоа. 
    # Т.е. у такой компании всего может быть один сотрудник
    free_tariff = prepare_free_tariff('free')
    assert_not_nil free_tariff

    company = prepare_company_1(user, free_tariff)
    assert_not_nil company

    assert_equal 1, company.az_employees.size
    assert_equal company.enabled_employees.size, company.az_employees.size
    assert company.employee_quota_reached
    assert company.employee_quota_exceed == false

    company.add_employee(employee)
    #company.reload
    assert_equal 1, company.az_employees.size
    assert company.employee_quota_reached
    assert company.employee_quota_exceed == false
    
  end

  test "AzCompany employee quota test 2" do

    # Добавление сотрудника к компании у которой не исчерпана квота по работникам, удаление и снова добавление нового юзера

    Authorization.current_user = nil
    user = prepare_user(:user)
    user1 = prepare_user(:user)
    user2 = prepare_user(:user)
    user3 = prepare_user(:user)

    # Создаем платный тариф с квотой на сотрудников равной 1. Т.е. один сотрудник помимо CEO
    tariff = prepare_paid_tariff_with_employees_quota('employee_quota_1', 1)
    assert_not_nil tariff

    company = prepare_company_1(user, tariff)
    assert_not_nil company

    assert_equal 1, company.az_employees.size
    assert_equal company.enabled_employees.size, company.az_employees.size
    assert company.employee_quota_reached == false
    assert company.employee_quota_exceed == false

    empl1 = company.add_employee(user1)
    assert_equal 2, company.az_employees.size
    assert_equal company.enabled_employees.size, company.az_employees.size
    assert company.employee_quota_reached
    assert company.employee_quota_exceed == false

    company.add_employee(user2)
    assert_equal 2, company.az_employees.size
    assert_equal company.enabled_employees.size, company.az_employees.size
    assert company.employee_quota_reached
    assert company.employee_quota_exceed == false

    # Увольнение
    company.delete_employee(empl1)
    assert_equal 1, company.az_employees.size
    assert_equal company.enabled_employees.size, company.az_employees.size
    assert company.employee_quota_reached == false
    assert company.employee_quota_exceed == false


    company.add_employee(user2)
    assert_equal 2, company.az_employees.size
    assert_equal company.enabled_employees.size, company.az_employees.size
    assert company.employee_quota_reached
    assert company.employee_quota_exceed == false

    company.add_employee(user3)
    assert_equal 2, company.az_employees.size
    assert_equal company.enabled_employees.size, company.az_employees.size
    assert company.employee_quota_reached
    assert company.employee_quota_exceed == false
    
  end

  test "AzCompany employee quota test 3" do

    # Добаввление сотрудников к компании с большой квотой, а потом даунгрейд тарифа на меньшее кол-во сотрудников

    Authorization.current_user = nil
    user = prepare_user(:user)
    user1 = prepare_user(:user)
    user2 = prepare_user(:user)
    user3 = prepare_user(:user)
    user4 = prepare_user(:user)

    # Создаем платный тариф с квотой на сотрудников равной 1. Т.е. один сотрудник помимо CEO
    
    empl_num_1 = 2
    empl_num_2 = 3
    tariff1 = prepare_paid_tariff_with_employees_quota('employee_quota_1', empl_num_1)
    tariff2 = prepare_paid_tariff_with_employees_quota('employee_quota_2', empl_num_2)

    assert_not_nil tariff1
    assert_not_nil tariff2

    company = prepare_company_1(user, tariff2)
    assert_not_nil company

    assert_equal 1, company.az_employees.size
    assert_equal company.enabled_employees.size, company.az_employees.size
    assert company.employee_quota_reached == false
    assert company.employee_quota_exceed == false

    empl1 = company.add_employee(user1)
    assert_equal 2, company.az_employees.size
    assert_equal company.enabled_employees.size, company.az_employees.size
    assert company.employee_quota_reached == false
    assert company.employee_quota_exceed == false

    empl2 = company.add_employee(user2)
    assert_equal 3, company.az_employees.size
    assert_equal company.enabled_employees.size, company.az_employees.size
    assert company.employee_quota_reached == false
    assert company.employee_quota_exceed == false

    empl3 = company.add_employee(user3)
    assert_equal 4, company.az_employees.size
    assert_equal company.enabled_employees.size, company.az_employees.size
    assert company.employee_quota_reached
    assert company.employee_quota_exceed == false

    company.add_employee(user4)
    assert_equal 4, company.az_employees.size
    assert_equal company.enabled_employees.size, company.az_employees.size
    assert company.employee_quota_reached
    assert company.employee_quota_exceed == false

    # Переход на меньший тариф
    company.change_tariff(tariff1)
    company.reload

    assert_equal 4, company.az_employees.size
    assert_equal company.enabled_employees.size + (empl_num_2 - empl_num_1), company.az_employees.size
    assert company.employee_quota_reached
    assert company.employee_quota_exceed == false
    
    empl1.reload
    empl2.reload
    empl3.reload

    assert empl1.disabled == false
    assert empl2.disabled == false
    assert empl3.disabled

    empl3.enable

    empl1.reload
    empl2.reload
    empl3.reload

    assert empl1.disabled == false
    assert empl2.disabled == false
    assert empl3.disabled

    company.delete_employee(empl2)

    empl3.enable
    
    empl1.reload
    empl3.reload

    assert empl1.disabled == false
    assert empl3.disabled == false
   
  end



  test "AzCompany employee quota test private projects" do
    # Тестирование работы с приватными проектами при переходах между тарифами

    Authorization.current_user = nil
    user = prepare_user(:user)

    assert is_table_size_equal?(AzProjectStatus, 0)
    create_statuses()
    assert is_table_size_equal?(AzProjectStatus, 8)


    # Создаем три тарифа с квотой на приватные проекты 0, 1 и 2
    
    #priv_prj_num_1 = 0
    #priv_prj_num_2 = 1
    #priv_prj_num_3 = 2
    tariff1 = prepare_tariff('free_tariff', 0, 0)
    tariff2 = prepare_tariff('paid_tariff_1', 10, 1)
    tariff3 = prepare_tariff('paid_tariff_2', 20, 2)

    assert_not_nil tariff1
    assert_not_nil tariff2
    assert_not_nil tariff3

    company = prepare_company_1(user, tariff1)
    assert_not_nil company

    project = create_project2(user, company, 'public project', true)
    assert_not_nil project

    private_project = create_project2(user, company, 'private project', false)
    assert_nil private_project

    # Переход на больший тариф
    company.change_tariff(tariff2)

    private_project = create_project2(user, company, 'private project 1', false)
    assert_not_nil private_project
    company.reload
    assert_equal company.private_projects.size, 1
    assert_equal 1, company.private_projects.select{|p| p.is_active?}.size

    private_project = create_project2(user, company, 'private project 2', false)
    assert_nil private_project
    company.reload
    assert_equal company.private_projects.size, 1
    assert_equal 1, company.private_projects.select{|p| p.is_active?}.size

    # Переход на больший тариф
    company.change_tariff(tariff3)

    private_project = create_project2(user, company, 'private project 3', false)
    assert_not_nil private_project
    company.reload
    assert_equal company.private_projects.size, 2
    assert_equal 2, company.private_projects.select{|p| p.is_active?}.size

    # Переход на меньший тариф
    company.change_tariff(tariff2)

    private_project = create_project2(user, company, 'private project 4', false)
    assert_nil private_project
    company.reload
    assert_equal company.private_projects.size, 2
    assert_equal 1, company.private_projects.select{|p| p.reload; p.is_active?}.size


    # Переход на бесплатный
    company.change_tariff(tariff1)

    private_project = create_project2(user, company, 'private project 5', false)
    assert_nil private_project
    company.reload
    assert_equal company.private_projects.size, 2
    assert_equal 0, company.private_projects.select{|p| p.reload; p.is_active?}.size
        
  end

end
