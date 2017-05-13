class AzProjectSnippetsController < ApplicationController

  def project_forbidden_url
    projects_url
  end
  
  layout "main"

  filter_access_to :all

  # GET /projects
  # GET /projects.xml
  def index
    @projects = AzProjectSnippet.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @projects }
    end
  end

  # GET /projects/1
  # GET /projects/1.xml
  def show
    @project = AzProjectSnippet.find(params[:id])
    respond_to do |format|
      #if @project.can_user_read(current_user)
        #format.html { render 'show_design'}
        if current_user == nil
          format.html { render 'plain_show'}
        else
          format.html { render 'show'}
        end
        format.xml
      #else
      #  format.html { redirect_to(project_forbidden_url) }
      #  format.xml  { render :xml => "ooooops" }
      #end
    end
  end

  # GET /projects/new
  # GET /projects/new.xml
  def new
    @az_project_snippet = AzProjectSnippet.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @az_project_snippet }
    end
  end

  # GET /projects/1/edit
  def edit
    @az_project_snippet = AzProjectSnippet.find(params[:id])

    if !@az_project_snippet.can_user_update(current_user)
      redirect_to(project_forbidden_url)
    end
  end

  # POST /projects
  # POST /projects.xml
  def create
    puts "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
    puts params[:az_project_snippet].inspect
    @project = AzProjectSnippet.new(params[:az_project_snippet])
    puts "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
    @project.owner_id = current_user.id
    @project.author_id = current_user.id

    ret = @project.save

    respond_to do |format|
      if ret
        flash[:notice] = 'AzProjectSnippet was successfully created.'
        format.html { redirect_to(@project) }
        #format.xml  { render :xml => @project, :status => :created, :location => @project }
      else
        format.html { render :action => "new" }
        #format.xml  { render :xml => @project.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /projects/1
  # PUT /projects/1.xml
  def update
    @az_project_snippet = AzProjectSnippet.find(params[:id])

    respond_to do |format|
      if !@az_project_snippet.can_user_update(current_user)
        format.html { redirect_to(project_forbidden_url) }
      elsif @az_project_snippet.update_attributes(params[:az_project_snippet])
        flash[:notice] = 'AzProjectSnippet was successfully updated.'
        format.html { redirect_to(@az_project_snippet) }
      else
        format.html { render :action => "edit" }
      end
    end
  end


  # DELETE /projects/1
  # DELETE /projects/1.xml
  def destroy
    @az_project_snippet = AzProjectSnippet.find(params[:id])

    if @az_project_snippet.can_user_delete(current_user)
      @az_project_snippet.destroy
    end

    respond_to do |format|
      format.html { redirect_to(az_project_snippets_path) }
      format.xml  { head :ok }
    end
  end

end
