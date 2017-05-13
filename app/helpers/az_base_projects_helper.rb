module AzBaseProjectsHelper

  def pages_collapsed(page_type)
    if session[:tr_pages_collapsed] == nil
      return false
    end

    if session[:tr_pages_collapsed][page_type] == nil || session[:tr_pages_collapsed][page_type] == false
      return false
    end

    return true
  end

end
