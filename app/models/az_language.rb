class AzLanguage < ActiveRecord::Base

  has_attached_file :lang_icon, :styles => { :x32 => "32x32"}

end
