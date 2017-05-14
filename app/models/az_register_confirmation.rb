require 'md5'

class AzRegisterConfirmation < ActiveRecord::Base

  def before_create
    self.confirm_hash = MD5.new('82h3' + Time.now.to_s + self.az_user.login).hexdigest
  end

  belongs_to :az_user
end
