# $Id: patch_for_mongrel.rb 168 2010-10-09 10:36:25Z imc $
# Fix for mongrel which still doesn't know about Rails 2.2's changes, 
# We provide a backwards compatible wrapper around the new
# ActionController::base.relative_url_root,
# so it can still be called off of the actually non-existing
# AbstractRequest class.

module ActionController
  class AbstractRequest < ActionController::Request
    def self.relative_url_root=(path)
      ActionController::Base.relative_url_root=(path)
    end
    def self.relative_url_root
      ActionController::Base.relative_url_root
    end
  end
end
#
# Thanks to http://www.ruby-forum.com/topic/190287
