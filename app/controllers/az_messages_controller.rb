class AzMessagesController < ApplicationController

  filter_access_to :all

  layout "main"

  # GET /az_messages
  # GET /az_messages.xml
  def index

    session[:message_filter] ||= {}
    @selected_statuses = {:status1 => -1, :status2 => -1, :status3 => -1}
    conditions = {}
    message_filter = session[:message_filter]
    if message_filter[:status1] && message_filter[:status1] >= 0
      conditions = conditions.merge({:status1 => message_filter[:status1]})
      @selected_statuses[:status1] = message_filter[:status1]
    end

    if message_filter[:status2] && message_filter[:status2] >= 0
      conditions = conditions.merge({:status2 => message_filter[:status2]})
      @selected_statuses[:status2] = message_filter[:status2]
    end

    if message_filter[:status3] && message_filter[:status3] >= 0
      conditions = conditions.merge({:status3 => message_filter[:status3]})
      @selected_statuses[:status3] = message_filter[:status3]
    end

    @az_messages = AzMessage.paginate(:page => params[:page], :order => 'id desc', :conditions => conditions)

    @statuses1 = AzMessage.statuses1
    @statuses2 = AzMessage.statuses2
    @statuses3 = AzMessage.statuses3

    users = AzUser.find(:all)
    @users_by_email = {}
    users.each do |user|
      if user.email != nil && user.email != ""
        @users_by_email[user.email] = user
      end
    end

    respond_to do |format|
      format.html 
      format.xml  { render :xml => @az_messages }
    end
  end

  # GET /az_messages/1
  # GET /az_messages/1.xml
  def show
    @az_message = AzMessage.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @az_message }
    end
  end

  # GET /az_messages/new
  # GET /az_messages/new.xml
  def new
    @az_message = AzMessage.new
    
    begin
      @az_message.email = current_user.email if !current_user.roles.include?(:visitor)
    rescue
    end

    respond_to do |format|
      format.html { render :layout => 'index' }
      format.xml  { render :xml => @az_message }
    end
  end

  # GET /az_messages/1/edit
  def edit
    @az_message = AzMessage.find(params[:id])
    @statuses1 = @az_message.statuses1
    @statuses2 = @az_message.statuses2
    @statuses3 = @az_message.statuses3

    @statuses1 = AzMessage.statuses1
    @statuses2 = AzMessage.statuses2
    @statuses3 = AzMessage.statuses3
  end

  # POST /az_messages
  # POST /az_messages.xml
  def create
    @az_message = AzMessage.new(params[:az_message])

    respond_to do |format|
      if @az_message.save
        #flash[:notice] = 'AzMessage was successfully created.'

        MessageMailer.deliver_new_message(AZ_EMAIL_FOR_MESSAGES, @az_message.email, @az_message.subject, @az_message.message)

        format.html { redirect_to(:action => 'created', :id=>1) }
        format.xml  { render :xml => @az_message, :status => :created, :location => @az_message }
      else
        format.html { render :layout => 'index', :action => "new" }
        format.xml  { render :xml => @az_message.errors, :status => :unprocessable_entity }
      end
    end
  end

  def created
    respond_to do |format|
      format.html { render :layout => 'index', :template => "/az_messages/created" }
      format.xml  { render :xml => @az_message }
    end
  end

  # PUT /az_messages/1
  # PUT /az_messages/1.xml
  def update
    @az_message = AzMessage.find(params[:id])

    respond_to do |format|
      if @az_message.update_attributes(params[:az_message])
        flash[:notice] = 'AzMessage was successfully updated.'
        format.html { redirect_to(@az_message) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @az_message.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /az_messages/1
  # DELETE /az_messages/1.xml
  def destroy
    message = AzMessage.find(params[:id])
    if message
      message.destroy
    end
    
    respond_to do |format|
      format.html { redirect_to(:action => :index) }
    end
  end

  def set_filter
    session[:message_filter] ||= {}
    
    session[:message_filter][:status1] = Integer(params[:status1])
    session[:message_filter][:status2] = Integer(params[:status2])
    session[:message_filter][:status3] = Integer(params[:status3])

    puts '=============================================================================='
    puts params.inspect
    puts session[:message_filter].inspect
    puts '=============================================================================='
    respond_to do |format|
      format.html { redirect_to(:back) }
    end
  end
end
