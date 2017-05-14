class MessageMailer < ActionMailer::Base

  include Resque::Mailer
  

  def new_message(email, sender_email, msg_subject, message, sent_at = Time.now)
    subject    msg_subject
    recipients email
    from       'noreply@azalo.net'
    sent_on    sent_at
    reply_to   sender_email
    body :email => sender_email, :message => message, :msg_subject => msg_subject
    content_type "text/html; charset=UTF-8"
  end

  def payment_message(email, company_name, company_id, description, amount, transaction_id, sent_at = Time.now)
    subject    "Azalo: платеж #{company_name}"
    recipients email
    from       'noreply@azalo.net'
    sent_on    sent_at
    body :company_name => company_name, :company_id => company_id, :description => description, :amount => amount, :transaction_id => transaction_id
  end

  def common_message(email, subject, text, sent_at = Time.now)
    subject    subject
    recipients email
    from       'noreply@azalo.net'
    sent_on    sent_at
    body :text => text
  end

  def cash_warning_message(email, subject, company_id, company_name, company_ceo_name, company_balance, warning_period_ends_at, sent_at = Time.now)
    subject    subject
    recipients email
    from       'noreply@azalo.net'
    sent_on    sent_at
    body(:company_id => company_id,
         :company_name => company_name,
         :company_ceo_name => company_ceo_name,
         :company_balance => company_balance,
         :warning_period_ends_at => warning_period_ends_at)
  end

end
