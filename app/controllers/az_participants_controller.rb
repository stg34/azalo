class AzParticipantsController < ApplicationController

  layout "main"

  filter_access_to :all

  # GET /az_participants
  # GET /az_participants.xml
  def index
    @az_participants = AzParticipant.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @az_participants }
    end
  end

  # GET /az_participants/1
  # GET /az_participants/1.xml
  def show
    @az_participant = AzParticipant.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @az_participant }
    end
  end

  # GET /az_participants/new
  # GET /az_participants/new.xml
  def new
    @az_participant = AzParticipant.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @az_participant }
    end
  end

  # GET /az_participants/1/edit
  def edit
    @az_participant = AzParticipant.find(params[:id])
  end

  # POST /az_participants
  # POST /az_participants.xml
  def create
    @az_participant = AzParticipant.new(params[:az_participant])

    respond_to do |format|
      if @az_participant.save
        flash[:notice] = 'AzParticipant was successfully created.'
        format.html { redirect_to(@az_participant) }
        format.xml  { render :xml => @az_participant, :status => :created, :location => @az_participant }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @az_participant.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /az_participants/1
  # PUT /az_participants/1.xml
  def update
    @az_participant = AzParticipant.find(params[:id])

    respond_to do |format|
      if @az_participant.update_attributes(params[:az_participant])
        flash[:notice] = 'AzParticipant was successfully updated.'
        format.html { redirect_to(@az_participant) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @az_participant.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /az_participants/1
  # DELETE /az_participants/1.xml
  def destroy
    @az_participant = AzParticipant.find(params[:id])
    @az_participant.destroy

    respond_to do |format|
      format.html { redirect_to(az_participants_url) }
      format.xml  { head :ok }
    end
  end
end
