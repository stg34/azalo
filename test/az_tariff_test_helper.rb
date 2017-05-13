ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_helper'
require 'declarative_authorization/maintenance'

class ActiveSupport::TestCase

  def prepare_tariff(name, price, private_tariffs_quota, quota_employees = 0)
    tariff = AzTariff.new
    tariff.quota_employees = quota_employees
    tariff.name = name
    tariff.price = price
    tariff.position = 0
    tariff.quota_private_projects = private_tariffs_quota
    tariff.tariff_type = AzTariff::Tariff_common
    tariff.save!
    return tariff
  end

  def prepare_free_tariff(name)
    return prepare_tariff(name, 0, 0)
  end

  def prepare_paid_tariff(name, price, private_tariffs_quota = 3)
    return prepare_tariff(name, price, private_tariffs_quota)
  end

  def prepare_paid_tariff_with_employees_quota(name, quota_employees, price = 10, private_tariffs_quota = 5)
    return prepare_tariff(name, price, private_tariffs_quota, quota_employees)
  end

end
