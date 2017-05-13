ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_helper'
require 'declarative_authorization/maintenance'

class ActiveSupport::TestCase
  
  def logger
    Rails.logger
  end

  def prepare_company_1(ceo, tariff)
    AzCompany.register_company(ceo, tariff)
  end

  def make_payment(company, amount, description)
    bt = AzBalanceTransaction.new
    bt.amount = amount
    bt.az_company = company
    bt.description = description
    bt.save
    return bt
  end

end
