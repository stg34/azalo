class AzContact < ActiveRecord::Base

  belongs_to :az_user
  attr_accessor :login
end

