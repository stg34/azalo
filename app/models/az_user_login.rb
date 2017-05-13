class AzUserLogin < ActiveRecord::Base
  belongs_to :az_user
  attr_accessible :az_user, :ip, :browser
end
