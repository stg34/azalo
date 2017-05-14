class RegisterConfirmationMailer < ActionMailer::Base

  include Resque::Mailer
  
  def confirm_registration(email, hash_str, host, sent_at = Time.now)
    subject    'Подтверждение регистрации'
    #recipients 'boris@stg.dp.ua'
    recipients email
    from       'register@azalo.net'
    sent_on    sent_at
    #body       :greeting => 'Hi,'
    #body       :confirmation_hash => '123456'
    #body['host'] = self.default_url_options[:host]
    body :host => host, :confirmation_hash => hash_str
  end

end
