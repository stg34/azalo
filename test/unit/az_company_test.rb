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

class AzCompanyTest < ActiveSupport::TestCase
  test "AzCompany create_default_content test" do

    clear_az_db

    Authorization.current_user = nil

    commons = [AzCommonsCommon,
              AzCommonsAcceptanceCondition,
              AzCommonsContentCreation,
              AzCommonsPurposeExploitation,
              AzCommonsPurposeFunctional,
              AzCommonsRequirementsHosting,
              AzCommonsRequirementsReliability]

    commons.each do |cmc|
      assert is_table_size_equal?(cmc, 0)
    end

    assert is_table_size_equal?(AzProject, 0)
    assert is_table_size_equal?(AzProjectBlock, 0)
    assert is_table_size_equal?(AzDefinition, 0)
    assert is_table_size_equal?(AzValidator, 0)

    user_seed = prepare_user(:user)
    assert_not_nil user_seed

    company_seed = prepare_company(user_seed)
    assert_not_nil company_seed

    project = create_project(user_seed, company_seed, 'project', true)
    assert_not_nil project
    assert project.seed == true

    struct = create_struct_data_type(user_seed, company_seed, 'struct', project)
    assert_not_nil struct

    simple_types = prepare_simple_data_types(user_seed, company_seed)
    assert_not_nil simple_types

    var = create_variable(user_seed, company_seed, struct, simple_types[0], "var_name")
    assert_not_nil var

    project_block = create_project_block(user_seed, company_seed, 'project', true)
    assert_not_nil project_block
    assert project_block.seed == true

    definition = create_definition(user_seed, company_seed, 'name', 'description', nil, true)
    assert_not_nil definition
    assert definition.seed == true

    validator = create_validator(user_seed, company_seed, 'name', 'description', 'message', "conditions", var, true)
    assert_not_nil validator
    assert validator.seed == true

    commons.each do |cmc|
      com = create_common(user_seed, company_seed, cmc, project, true)
      assert_not_nil com
      assert com.seed == true
    end

    assert is_table_size_equal?(AzProject, 1)
    assert AzProject.get_seeds.size == 1

    assert is_table_size_equal?(AzProjectBlock, 1)
    assert AzProjectBlock.get_seeds.size == 1

    assert is_table_size_equal?(AzDefinition, 1)
    assert AzDefinition.get_seeds.size == 1

    assert is_table_size_equal?(AzValidator, 1)
    assert AzValidator.get_seeds.size == 1

    commons.each do |c|
      assert c.get_seeds.size == 1
      assert is_table_size_equal?(c, 1)
    end

    Authorization.current_user = nil
    user_new = prepare_user(:user)
    assert_not_nil user_new

    company_new = prepare_company(user_new)
    assert_not_nil company_new

    Authorization.current_user = user_new
    company_new.create_default_content

 end
 # ---------------------------------------------------------------------------

  test "AzCompany new_tariff_test_1_2" do

    clear_az_db

    # Тесты соотв. рис. 1 и 2
    
    Authorization.current_user = nil
    user = prepare_user(:user)
    tariff_price = 310
    paid_tariff = prepare_paid_tariff('paid_100', tariff_price)
    new_month_time = Time.local(2012, 1, 1, 0, 0, 0)
    # set date to 2012 jan 10
    register_time = Time.local(2012, 1, 10, 0, 0, 0)
    Timecop.travel(register_time)
    company = prepare_company_1(user, paid_tariff)

    # Зарегистрировали компанию на плтаный тариф

    assert_not_nil company.az_warning_period
    puts "delta seconds: #{register_time - new_month_time}"
    puts "balance: #{company.get_balance}"
    puts (31*24*3600 - (register_time - new_month_time))/(31*24*3600)
    puts company.get_balance/tariff_price

    # Денег должно сняться за период до конца месяца.
    assert_in_delta(-company.get_balance/tariff_price, (31*24*3600 - (register_time - new_month_time))/(31*24*3600), 0.001)
    #(register_time - new_month_time)/31*24*3600 == company.get_balance/tariff_price

    assert !company.get_locked

    # Сразу пополняем счет
    puts "make_payment for #{-company.get_balance + 0.01}"
    make_payment(company, -company.get_balance + 0.01, 'test')
    assert_nil company.az_warning_period

    assert !company.get_locked

    # Ждем до начала месяца и списывем деньги за тариф
    new_month_time = Time.local(2012, 2, 1, 0, 0, 0)
    Timecop.travel(new_month_time)
    company.charge_fee

    assert_not_nil company.az_warning_period

    puts "balance: #{company.get_balance}"

    # Денег должно списасаться за полный месяц
    assert_in_delta(-company.get_balance, tariff_price, 0.01)

    assert !company.get_locked

    # Просрачиваем период предупреждений
    Timecop.travel(new_month_time + AZ_WARNING_PERIOD + 1)

    # Компанию заблокировали за неуплату
    assert company.get_locked

    # Пополнили половину денег, не разблокировали компанию
    make_payment(company, -company.get_balance/2, 'test')
    assert_not_nil company.az_warning_period
    assert company.get_locked

    # Пополнили еще половину денег, разблокировали компанию
    make_payment(company, -company.get_balance + 0.01, 'test')
    assert_nil company.az_warning_period
    assert !company.get_locked

    # Ждем до начала месяца и списывем деньги за тариф
    new_month_time = Time.local(2012, 3, 1, 0, 0, 0)
    Timecop.travel(new_month_time)
    company.charge_fee
    company_balance = company.get_balance

    # Ждем еще начала месяца и списывем деньги за тариф, деньги не должны списаться, т.к. компания заблокирована
    new_month_time = Time.local(2012, 4, 1, 0, 0, 0)
    Timecop.travel(new_month_time)
    company.charge_fee
    assert company_balance == company.get_balance

    Timecop.return
  end


  test "AzCompany new_tariff_test_3" do

    clear_az_db

    # Тесты соотв. рис. 3

    Authorization.current_user = nil
    user = prepare_user(:user)
    tariff_price = 310
    paid_tariff = prepare_paid_tariff('paid_100', tariff_price)
    free_tariff = prepare_free_tariff('free')
    new_month_time = Time.local(2012, 1, 1, 0, 0, 0)
    # set date to 2012 jan 10
    register_time = Time.local(2012, 1, 10, 0, 0, 0)
    Timecop.travel(register_time)
    company = prepare_company_1(user, free_tariff)

    # Зарегистрировали компанию на бесплтаный тариф
    assert_nil company.az_warning_period
    assert !company.get_locked
    
    # Денег не должно сняться
    assert company.get_balance ==  0

    # Ждем до начала месяца и списывем деньги за тариф
    new_month_time = Time.local(2012, 2, 1, 0, 0, 0)
    Timecop.travel(new_month_time)
    company.charge_fee


    # Денег не должно сняться
    assert company.get_balance ==  0
    assert_nil company.az_warning_period
    assert !company.get_locked


    # Ждем средину месяца и меняем тариф на платный
    dt = Time.local(2012, 3, 1, 0, 0, 0) - Time.local(2012, 2, 1, 0, 0, 0)
    new_time = Time.local(2012, 2, 1, 0, 0, 0) + dt/2
    Timecop.travel(new_time)
    company.change_tariff(paid_tariff)

    # Должно произойти списание денег за половину месяца
    assert_in_delta(-company.get_balance, tariff_price/2, 0.01)
    assert !company.get_locked
    assert_not_nil company.az_warning_period
    
    # Просрачиваем период предупреждений, компания должна быть заблокирована
    Timecop.travel(new_time + AZ_WARNING_PERIOD + 1)
    assert company.get_locked
    assert_not_nil company.az_warning_period

    # Пополнили денег, разблокировали компанию
    make_payment(company, -company.get_balance + 0.01, 'test')
    assert_nil company.az_warning_period
    assert !company.get_locked


    # Ждем до начала месяца и списывем деньги за тариф
    new_month_time = Time.local(2012, 3, 1, 0, 0, 0)
    Timecop.travel(new_month_time)
    company.charge_fee

    # Должно произойти списание денег за месяц
    assert_in_delta(-company.get_balance, tariff_price, 0.01)
    assert !company.get_locked
    assert_not_nil company.az_warning_period

    # Просрачиваем период предупреждений, компания должна быть заблокирована
    Timecop.travel(new_month_time + AZ_WARNING_PERIOD + 1)
    assert company.get_locked
    assert_not_nil company.az_warning_period

    Timecop.return
  end


  test "AzCompany new_tariff_test_4_a" do


    clear_az_db

    # Тест 4 а

    Authorization.current_user = nil
    user = prepare_user(:user)
    tariff_price = 310
    paid_tariff = prepare_paid_tariff('paid_100', tariff_price)
    new_month_time = Time.local(2012, 1, 1, 0, 0, 0)

    # set date to 2012 jan 10
    register_time = Time.local(2012, 2, 1, 0, 0, 0) - AZ_WARNING_PERIOD/2
    Timecop.travel(register_time)
    company = prepare_company_1(user, paid_tariff)
    assert_not_nil company.az_warning_period
    puts "delta seconds: #{register_time - new_month_time}"
    puts "balance: #{company.get_balance}"
    puts (31*24*3600.0 - (register_time - new_month_time))/(31*24*3600.0)
    puts company.get_balance/tariff_price
    assert_in_delta(-company.get_balance/tariff_price, (31*24*3600.0 - (register_time - new_month_time))/(31*24*3600.0), 0.001)
    #(register_time - new_month_time)/31*24*3600 == company.get_balance/tariff_price

    assert !company.get_locked

    puts "make_payment for #{-company.get_balance + 0.01}"
    make_payment(company, -company.get_balance + 0.01, 'test')
    assert_nil company.az_warning_period

    assert !company.get_locked

    new_month_time = Time.local(2012, 2, 1, 0, 0, 0)
    Timecop.travel(new_month_time)
    company.charge_fee

    assert !company.get_locked

    Timecop.return
  end

  test "AzCompany new_tariff_test_4" do

    clear_az_db

    # Тест 4

    Authorization.current_user = nil
    user = prepare_user(:user)
    tariff_price = 310
    paid_tariff = prepare_paid_tariff('paid_100', tariff_price)
    new_month_time = Time.local(2012, 1, 1, 0, 0, 0)
    # set date to 2012 jan 10
    register_time = Time.local(2012, 1, 10, 0, 0, 0)
    Timecop.travel(register_time)
    company = prepare_company_1(user, paid_tariff)
    assert_not_nil company.az_warning_period
    puts "delta seconds: #{register_time - new_month_time}"
    puts "balance: #{company.get_balance}"
    puts (31*24*3600 - (register_time - new_month_time))/(31*24*3600)
    puts company.get_balance/tariff_price
    assert_in_delta(-company.get_balance/tariff_price, (31*24*3600 - (register_time - new_month_time))/(31*24*3600), 0.001)
    #(register_time - new_month_time)/31*24*3600 == company.get_balance/tariff_price

    assert !company.get_locked

    make_payment(company, -1.01 * company.get_balance, 'test')
    assert_nil company.az_warning_period

    assert !company.get_locked

    # set date to 2012 jan 10
    #company.charge_part_of_fee(Time.now)
    Timecop.return
  end

  test "AzCompany new_tariff_test_5" do

    clear_az_db

    # Тест 5

    Authorization.current_user = nil
    user = prepare_user(:user)

    paid_tariff = prepare_paid_tariff('paid_1', 310)
    paid_tariff_2 = prepare_paid_tariff('paid_2', 620)
    paid_tariff_3 = prepare_paid_tariff('paid_3', 500)

    assert paid_tariff_2.price > paid_tariff_3.price # Необходимо для проверки перехода на пониженный тариф

    new_month_time = Time.local(2012, 1, 1, 0, 0, 0)

    # переходим на 2012 jan 10, регистрируем компанию
    register_time = Time.local(2012, 1, 10, 0, 0, 0)
    Timecop.travel(register_time)
    company = prepare_company_1(user, paid_tariff)
    assert_not_nil company.az_warning_period
    puts "delta seconds: #{register_time - new_month_time}"
    puts "balance: #{company.get_balance}"
    puts (31*24*3600 - (register_time - new_month_time))/(31*24*3600)
    puts company.get_balance/paid_tariff.price
    assert_in_delta(-company.get_balance/paid_tariff.price, (31*24*3600 - (register_time - new_month_time))/(31*24*3600), 0.001)
    #(register_time - new_month_time)/31*24*3600 == company.get_balance/tariff_price
    assert !company.get_locked

    # переходим вперед на половину периода WARN
    payment_time = register_time + AZ_WARNING_PERIOD/2
    Timecop.travel(payment_time)
    assert !company.get_locked
    make_payment(company, -1.01 * company.get_balance, 'test')
    assert_nil company.az_warning_period
    assert !company.get_locked

    # переходим вперед 20 число и меняем тариф на более дорогой
    cahange_tariff_time = Time.local(2012, 1, 20, 0, 0, 0)
    Timecop.travel(cahange_tariff_time)

    balance_bofore_tariff_change = company.get_balance
   
    company.change_tariff(paid_tariff_2)

    balance_after_tariff_change = company.get_balance

    delta_cash = balance_bofore_tariff_change - balance_after_tariff_change
    puts delta_cash
    #delta_time = new_month_time - cahange_tariff_time
    next_month_time = Time.local(2012, 2, 1, 0, 0, 0)
    delta_time = next_month_time - cahange_tariff_time

    #puts delta_time
    
    #отношение периода месяца, когда действует дорогой тариф к длине месяца
    ratio_time = delta_time/(next_month_time - new_month_time)
    
    #изменения денег с учетом возврата денег за более дешевый тариф (это выражено в .../(tariff2_price - tariff_price) )
    ratio_cash = delta_cash/(paid_tariff_2.price - paid_tariff.price)
  
    assert_in_delta(ratio_time, ratio_cash, 0.001)

    # Промотка до 1-го февраля, снятие новой абонплаты
    Timecop.travel(next_month_time - 60) #За минуту до нового месяца
    assert company.get_locked
    make_payment(company, -company.get_balance + 0.01, 'test')
    assert !company.get_locked

    balance_bofore_new_month = company.get_balance
    Timecop.travel(next_month_time + 60) # +60 посмотреть, что снятие АП сработаен нормально, даже если будет запущено с опозданием
    company.charge_fee
    balance_after_new_month = company.get_balance

    puts "balance_bofore_new_month: #{balance_bofore_new_month}"
    puts "balance_after_new_month: #{balance_after_new_month}"

    assert_in_delta(balance_bofore_new_month - balance_after_new_month, paid_tariff_2.price, 0.001)

    make_payment(company, -company.get_balance + 0.01, 'test')
    Timecop.travel(next_month_time + AZ_WARNING_PERIOD + 1)
    assert !company.get_locked

    Timecop.travel(next_month_time + 14*24*3600)

    balance_bofore_tariff_change = company.get_balance
    company.change_tariff(paid_tariff_3)
    balance_after_tariff_change = company.get_balance
    delta_cash = balance_bofore_tariff_change - balance_after_tariff_change
    puts "delta_cash: #{delta_cash}"


    secs_in_month = Time.local(2012, 3, 1, 0, 0, 0) - Time.local(2012, 2, 1, 0, 0, 0)
    rest_of_month = Time.local(2012, 3, 1, 0, 0, 0) - (next_month_time + 14*24*3600)

    refund_coeff = AzCompany::Refund_tariff_coeff
    refund_value = paid_tariff_2.price*refund_coeff*(rest_of_month/secs_in_month)
    new_tariff_fee = paid_tariff_3.price*(rest_of_month/secs_in_month)

    puts "secs_in_month: #{secs_in_month}"
    puts "rest_of_month #{rest_of_month}"
    puts "refund_value: #{refund_value}"
    puts "new_tariff_fee: #{new_tariff_fee}"

    assert_in_delta(balance_bofore_tariff_change + refund_value - new_tariff_fee, balance_after_tariff_change, 0.01)

    #Refund_tariff_coeff

    # set date to 2012 jan 10
    #company.charge_part_of_fee(Time.now)
    Timecop.return
  end



  test "AzCompany free tariff and public and private projects" do

    clear_az_db

    # Проверка на создание приватных проектов у компании с бесплатным тарифом

    Authorization.current_user = nil
    user = prepare_user(:user)
    create_statuses()

    free_tariff = prepare_free_tariff('free')
    paid_tariff_1 = prepare_paid_tariff('paid_1', 310, 3)
    paid_tariff_2 = prepare_paid_tariff('paid_1', 310, 5)

    new_month_time = Time.local(2012, 1, 1, 0, 0, 0)

    # переходим на 2012 jan 10, регистрируем компанию с бесплатным тарифом
    # мы можем создавать открытые проекты, приватные - нет
    register_time = Time.local(2012, 1, 10, 0, 0, 0)
    Timecop.travel(register_time)
    company = prepare_company_1(user, free_tariff)

    public_project = create_project2(user, company, 'public project 1', true)
    assert_not_nil public_project
    
    private_project = create_project2(user, company, 'private project 1', false)
    assert_nil private_project

    public_project2 = create_project2(user, company, 'public project 2', true)
    assert_not_nil public_project2
    
    # переходим вперед 15 число и меняем тариф на более дорогой
    cahange_tariff_time = Time.local(2012, 1, 15, 0, 0, 0)
    Timecop.travel(cahange_tariff_time)
    company.change_tariff(paid_tariff_1)

    private_project2 = create_project2(user, company, 'private project 2', false)
    assert_not_nil private_project2

    # переходим вперед на период WARN, после этого мы доложны быть заблокированы и не иметь возможности создавать проекты
    lock_time = cahange_tariff_time + AZ_WARNING_PERIOD + 1
    Timecop.travel(lock_time)
    assert company.get_locked

    public_project3 = create_project2(user, company, 'public project 3', true)
    assert_nil public_project3

    private_project3 = create_project2(user, company, 'private project 3', false)
    assert_nil private_project3

    # гасим долг, и после этого мы доложны иметь возможности создавать проекты
    make_payment(company, -company.get_balance + 0.01, 'test')

    public_project4 = create_project2(user, company, 'public project 4', true)
    assert_not_nil public_project4

    private_project4 = create_project2(user, company, 'private project 4', false)
    assert_not_nil private_project4

    # Переходим на бесплатьный тариф, теперь можем создать открытый проект, приватный - нет
    company.change_tariff(free_tariff)

    public_project5 = create_project2(user, company, 'public project 5', true)
    assert_not_nil public_project5

    private_project5 = create_project2(user, company, 'private project 5', false)
    assert_nil private_project5
  
    Timecop.return
  end


  test "AzCompany copying project by locked company" do
    # Попытка копирования чужого проекта в заблокированную компанию

    clear_az_db

    Authorization.current_user = nil
    user = prepare_user(:user)
    foreign_user = prepare_user(:user)

    free_tariff = prepare_free_tariff('free')
    paid_tariff_1 = prepare_paid_tariff('paid_1', 310, 3)
    paid_tariff_2 = prepare_paid_tariff('paid_1', 310, 5)

    new_month_time = Time.local(2012, 1, 1, 0, 0, 0)

    # переходим на 2012 jan 10, регистрируем компанию с бесплатным тарифом
    # мы можем создавать открытые проекты, приватные - нет
    register_time = Time.local(2012, 1, 10, 0, 0, 0)
    Timecop.travel(register_time)
    company = prepare_company_1(user, free_tariff)

    foreign_company = prepare_company_1(foreign_user, paid_tariff_1)
    make_payment(foreign_company, 1000000, 'test')

    foreign_public_project = create_project2(foreign_user, foreign_company, 'foreign public project 1', true)
    assert_not_nil foreign_public_project
    
    # переходим вперед 15 число и меняем тариф на более дорогой
    cahange_tariff_time = Time.local(2012, 1, 15, 0, 0, 0)
    Timecop.travel(cahange_tariff_time)
    company.change_tariff(paid_tariff_1)

    # переходим вперед на период WARN, после этого мы доложны быть заблокированы и не иметь возможности создавать проекты
    lock_time = cahange_tariff_time + AZ_WARNING_PERIOD + 1
    Timecop.travel(lock_time)
    assert company.get_locked
    assert foreign_company.get_locked == false

    foreign_project = create_project(foreign_user, foreign_company, 'foreign project')
    assert_not_nil foreign_project

    project_copy = foreign_project.fork(company)
    assert_nil project_copy
  
    Timecop.return
  end

end
