class AzBalanceTransaction < ActiveRecord::Base
  belongs_to :az_company
  has_one :az_invoice, :dependent => :destroy

  def after_create
    puts "after_create AzBalanceTransaction"
    balance = az_company.get_balance
    if (balance > 0)
      az_company.destroy_warning_period
    end

    msg = "Изменение счета #{self.az_company.name} #{self.amount}"
    body = "Изменение счета #{self.az_company.name} #{self.amount}. Баланс: #{balance}"
    if Rails.env == 'production'
      MessageMailer.deliver_new_message(AZ_EMAIL_FOR_MESSAGES, "info@azalo.net", msg, body)
    end
  end

end
