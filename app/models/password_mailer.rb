class PasswordMailer < ActionMailer::Base

  include Resque::Mailer

  def reset_password_hash(login, name, email, hash_str, host, sent_at = Time.now)
    subject    'Azalo.net: Восстановление пароля'
    recipients email
    from       'noreply@azalo.net'
    sent_on    sent_at
    body :host => host, :reset_hash => hash_str, :login => login, :name => name
  end

end
