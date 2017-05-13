class AzScetchProgramsController < ApplicationController

  filter_access_to :all

  layout 'main'

  # GET /az_scetch_programs
  # GET /az_scetch_programs.xml
  def index
    @az_scetch_programs = AzScetchProgram.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @az_scetch_programs }
    end
  end

  # GET /az_scetch_programs/1
  # GET /az_scetch_programs/1.xml
  def show
    @az_scetch_program = AzScetchProgram.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @az_scetch_program }
    end
  end

  # GET /az_scetch_programs/new
  # GET /az_scetch_programs/new.xml
  def new
    @az_scetch_program = AzScetchProgram.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @az_scetch_program }
    end
  end

  # GET /az_scetch_programs/1/edit
  def edit
    @az_scetch_program = AzScetchProgram.find(params[:id])
  end

  # POST /az_scetch_programs
  # POST /az_scetch_programs.xml
  def create
    @az_scetch_program = AzScetchProgram.new(params[:az_scetch_program])

    respond_to do |format|
      if @az_scetch_program.save
        format.html { redirect_to(@az_scetch_program, :notice => 'AzScetchProgram was successfully created.') }
        format.xml  { render :xml => @az_scetch_program, :status => :created, :location => @az_scetch_program }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @az_scetch_program.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /az_scetch_programs/1
  # PUT /az_scetch_programs/1.xml
  def update
    @az_scetch_program = AzScetchProgram.find(params[:id])

    respond_to do |format|
      if @az_scetch_program.update_attributes(params[:az_scetch_program])
        format.html { redirect_to(@az_scetch_program, :notice => 'AzScetchProgram was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @az_scetch_program.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /az_scetch_programs/1
  # DELETE /az_scetch_programs/1.xml
  def destroy
    @az_scetch_program = AzScetchProgram.find(params[:id])
    @az_scetch_program.destroy

    respond_to do |format|
      format.html { redirect_to(az_scetch_programs_url) }
      format.xml  { head :ok }
    end
  end
end
