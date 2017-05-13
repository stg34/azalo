# This controller handles the login/logout function of the site.
class SessionsController < ApplicationController
  # This controller has no filter_access_to statements, as everyone
  # may try to login or logout.

  layout "main"

  # render new.rhtml
  def new
    
  end

  def create
    @news = AzNews.get_latest_news
    logout_keeping_session!
    user = AzUser.authenticate(params[:login], params[:password])
    user = AzUser.find_by_login(params[:login]) if params[:force] and not user
    if user && !user.disabled
      # Protects against session fixation attacks, causes request forgery
      # protection if user resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset_session
      self.current_user = user

      remote_ip = request.env["HTTP_X_FORWARDED_FOR"]
      if remote_ip == nil || remote_ip == ''
        remote_ip = request.remote_ip
      end

      user_login = AzUserLogin.new(:az_user => user, :ip => remote_ip, :browser => request.env["HTTP_USER_AGENT"])
      user_login.save

      #new_cookie_flag = (params[:remember_me] == "1")
      #handle_remember_cookie! new_cookie_flag
      redirect_back_or_default('/')
      #flash[:notice] = "Logged in successfully"
      flash[:notice] = ""
    else
      flash[:notice] = "Неверный логин или пароль."
      note_failed_signin
      @login       = params[:login]
      @remember_me = params[:remember_me]
      render :action => 'new'
    end
  end

  def destroy
    logout_killing_session!
    flash[:notice] = "Приходите еще."
    redirect_back_or_default('/')
  end

protected
  # Track failed login attempts
  def note_failed_signin
    flash[:error] = "Couldn't log you in as '#{params[:login]}'"
    logger.warn "Failed login for '#{params[:login]}' from #{request.remote_ip} at #{Time.now.utc}"
  end
end
