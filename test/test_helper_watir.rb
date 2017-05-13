require 'rubygems'
require 'watir-webdriver'

class W_test

  Host = 'http://localhost:3000'

  def initialize
    @b = Watir::Browser.new
  end

  def logged_in?
    return @b.div(:class => 'hello').exists?
  end

  def logout
    @b.goto(Host + '/logout')
  end

  def login(login, password)
    @b.goto(Host)
    @b.link(:class => 'login').click
    @b.text_field(:id => 'login').set(login)
    @b.text_field(:id => 'password').set(password)
    @b.button(:name => 'commit').click
    
    if !logged_in?
      return false
    end
    
    return @b.div(:class => 'hello').text.include?(login)
  end

  def view_news
    @b.goto(Host)
    news_link = @b.element(:css => '.announce a')

    if !news_link.exists?
      puts 'news_link doesn\'t exist'
      return false
    end

    news_link.click

    @b.goto(Host)

    news_archive_link = @b.element(:css => '.new-archive-link-holder a')

    if !news_archive_link.exists?
      puts 'news_archive_link doesn\'t exist'
      return false
    end

    news_archive_link.click

    return true

  end


  def view_recover_password
    logout
    @b.link(:class => 'login').click

    recover_password_link = @b.link(:class => 'recover-password-link')

    if !recover_password_link.exists?
      puts 'recover_password_link doesn\'t exist'
      return false
    end

    recover_password_link.click

    @b.text_field(:id => 'az_user_email').set('stg34@ua.fm')
    @b.button(:name => 'commit').click

    return true

  end
  

end
