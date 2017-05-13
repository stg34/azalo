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

require 'capybara'
require 'capybara/dsl'
require 'selenium/webdriver'

Capybara.run_server = false
Capybara.current_driver = :selenium
Capybara.app_host = 'http://localhost:3000'

Selenium::WebDriver::Firefox::Binary.path = "/home/boris/opt/firefox-7.0.1/firefox"

class AzCompanyTest2 < ActiveSupport::TestCase
  include Capybara::DSL

  test "AzCompany ceo not disabled" do

    Authorization.current_user = nil
    user = prepare_user(:user)

    free_tariff = prepare_free_tariff('free')
    assert_not_nil free_tariff

    # Создали компанию, uesr - CEO
    company = prepare_company_1(user, free_tariff)
    assert_not_nil company

    visit('/login')

    within(".login-block") do
      fill_in 'login', :with => 'user@example.com'
      fill_in 'password', :with => 'password'
    end
    click_button 'Войти'

    sleep 10
  end

end
