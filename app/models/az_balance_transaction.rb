class AzBalanceTransaction < ActiveRecord::Base
  belongs_to :az_company
  has_one :az_invoice, :dependent => :destroy

  after_create :destroy_warning_period

  def destroy_warning_period
    balance = az_company.get_balance
    if balance > 0
      az_company.destroy_warning_period
    end

    msg = "Изменение счета #{self.az_company.name} #{self.amount}"
    body = "Изменение счета #{self.az_company.name} #{self.amount}. Баланс: #{balance}"

    MessageMailer.new_message(AZ_EMAIL_FOR_MESSAGES, 'info@azalo.net', msg, body).deliver
  end

end
