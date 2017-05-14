class BalanceObserver < ActiveRecord::Observer

  observe(AzCompany)

  def before_update(model)

  end

  def after_update(company)

  end
end
