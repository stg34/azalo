class AzSettingsController < ApplicationController

  filter_access_to :all

  layout "main"

  def index
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def configuration
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def seeds
    @seed_project_blocks = AzProjectBlock.get_seeds
    @seed_projects = AzProject.get_seeds
    @seed_structs = AzStructDataType.get_seeds
    @seed_commons = AzCommon.get_seeds
    @seed_definitions = AzDefinition.get_seeds
    respond_to do |format|
      format.html { render :template => 'az_settings/seeds'}
    end
  end
  
end
