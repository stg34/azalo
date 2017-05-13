class AzUserSettingsController < ApplicationController

  filter_access_to :all

  layout "main"

  def index
    @title = 'Кладовка'

    respond_to do |format|
      format.html # index.html.erb
    end
  end
  
end
