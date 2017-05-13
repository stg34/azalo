class AzScetchProgram < ActiveRecord::Base

  has_attached_file :sp_icon, :styles => { :x32 => "32x32"}

end
