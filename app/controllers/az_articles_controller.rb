class AzArticlesController < ApplicationController
  # GET /az_articles
  # GET /az_articles.xml

  filter_access_to :all

  layout "main"

  def index
    @az_articles = AzArticle.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @az_articles }
    end
  end

  def index_public
    @az_articles = AzArticle.paginate(:all, :page => params[:page], :conditions => {:visible => true}, :order => 'created_at desc')

    respond_to do |format|
      format.html { render :template => 'az_articles/index_public', :layout => 'index' }
      format.xml  { render :xml => @az_articles }
    end
  end

  # GET /az_articles/1
  # GET /az_articles/1.xml
  def show
    @az_article = AzArticle.find(params[:id])

    respond_to do |format|
      format.html { render :layout => 'index' }
      format.xml  { render :xml => @az_article }
    end
  end

  # GET /az_articles/new
  # GET /az_articles/new.xml
  def new
    @az_article = AzArticle.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @az_article }
    end
  end

  # GET /az_articles/1/edit
  def edit
    @az_article = AzArticle.find(params[:id])
    @az_article.az_c_images << AzCImage.new
    @az_article.az_c_images << AzCImage.new
    @az_article.az_c_images << AzCImage.new
  end

  # POST /az_articles
  # POST /az_articles.xml
  def create
    @az_article = AzArticle.new(params[:az_article])

    respond_to do |format|
      if @az_article.save
        format.html { redirect_to(@az_article, :notice => 'AzArticle was successfully created.') }
        format.xml  { render :xml => @az_article, :status => :created, :location => @az_article }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @az_article.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /az_articles/1
  # PUT /az_articles/1.xml
  def update
    @az_article = AzArticle.find(params[:id])

    respond_to do |format|
      if @az_article.update_attributes(params[:az_article])
        format.html { redirect_to(@az_article, :notice => 'AzArticle was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @az_article.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /az_articles/1
  # DELETE /az_articles/1.xml
  def destroy
    @az_article = AzArticle.find(params[:id])
    @az_article.destroy

    respond_to do |format|
      format.html { redirect_to(az_articles_url) }
      format.xml  { head :ok }
    end
  end
end
