class InvitationMailer < ActionMailer::Base

  include Resque::Mailer

  def invitation_to_site(email, hash_str, user_name, host, sent_at = Time.now)
    subject    "#{user_name} приглашает на сайт Azalo.net"
    recipients email
    from       'register@azalo.net'
    sent_on    sent_at
    body :host => self.default_url_options[:host], :hash_str => hash_str, :email => email,  :user_name => user_name
  end

  def invitation_to_company(email, hash_str, company_name, user_name, host, sent_at = Time.now)
    subject    "#{user_name} приглашает на сайт Azalo.net"
    recipients email
    from       'register@azalo.net'
    sent_on    sent_at
    body :host => host, :hash_str => hash_str, :email => email, :company_name => company_name, :user_name => user_name
  end

  def invitation_to_company_existing_user(email, hash_str, company_name, user_name, host, sent_at = Time.now)
    subject    "#{user_name} приглашает на сайт Azalo.net"
    recipients email
    from       'register@azalo.net'
    sent_on    sent_at
    body :host => host, :hash_str => hash_str, :email => email, :company_name => company_name, :user_name => user_name
  end
end
