require 'digest/md5'

class AzResetPassword < ActiveRecord::Base

  belongs_to :az_user
  
  validates_presence_of :az_user_id

  after_create :destroy_old_resets
  before_create :create_hash_str

  def create_hash_str
    self.hash_str = self.hash_str = MD5.new('w87a2hz' + Time.now.to_s).hexdigest
  end

  def destroy_old_resets

    AzResetPassword.delete_all('created_at < DATE_ADD(Now(), INTERVAL -30 DAY)')
    
    resets = AzResetPassword.find_all_by_az_user_id(self.az_user_id)
    resets.each do |r|
      if r.id != self.id
        r.destroy()
      end
    end

  end

end
