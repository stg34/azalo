class AzLanguagesController < ApplicationController

  filter_access_to :all

  layout 'main'

  # GET /az_languages
  # GET /az_languages.xml
  def index
    @az_languages = AzLanguage.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @az_languages }
    end
  end

  # GET /az_languages/1
  # GET /az_languages/1.xml
  def show
    @az_language = AzLanguage.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @az_language }
    end
  end

  # GET /az_languages/new
  # GET /az_languages/new.xml
  def new
    @az_language = AzLanguage.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @az_language }
    end
  end

  # GET /az_languages/1/edit
  def edit
    @az_language = AzLanguage.find(params[:id])
  end

  # POST /az_languages
  # POST /az_languages.xml
  def create
    @az_language = AzLanguage.new(params[:az_language])

    respond_to do |format|
      if @az_language.save
        format.html { redirect_to(@az_language, :notice => 'AzLanguage was successfully created.') }
        format.xml  { render :xml => @az_language, :status => :created, :location => @az_language }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @az_language.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /az_languages/1
  # PUT /az_languages/1.xml
  def update
    @az_language = AzLanguage.find(params[:id])

    respond_to do |format|
      if @az_language.update_attributes(params[:az_language])
        format.html { redirect_to(@az_language, :notice => 'AzLanguage was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @az_language.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /az_languages/1
  # DELETE /az_languages/1.xml
  def destroy
    @az_language = AzLanguage.find(params[:id])
    @az_language.destroy

    respond_to do |format|
      format.html { redirect_to(az_languages_url) }
      format.xml  { head :ok }
    end
  end
end
