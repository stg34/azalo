require 'digest/md5'

class AzRegisterConfirmation < ActiveRecord::Base

  belongs_to :az_user

  before_create :create_confirm_hash

  def create_confirm_hash
    self.confirm_hash = MD5.new('82h3' + Time.now.to_s + self.az_user.login).hexdigest
  end

end
