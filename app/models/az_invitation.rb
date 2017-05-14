require 'md5'

class AzInvitation < ActiveRecord::Base

  validates_presence_of     :email
  validates_length_of       :email,    :within => 6..100 #r@a.wk
  #validates_uniqueness_of   :email
  validates_format_of       :email,    :with => Authentication.email_regex, :message => Authentication.bad_email_message

  validates_presence_of     :invitation_type
  validates_format_of       :invitation_type,  :with => /(site|company)/

  attr_protected :hash_str
  attr_protected :invitation_type
  attr_protected :invitation_data

  belongs_to :az_user, :foreign_key => :user_id

  #attr_protected :owner_id

  def before_validation
    # TODO проверить, что такого хэша еще нет
    self.hash_str = MD5.new('w8882h3' + Time.now.to_s + self.invitation_data.to_s).hexdigest

    if self.invitation_type == 'company'
      user = AzUser.find_by_email(self.email)
      if user != nil
        self.user_id = user.id
      end
    end
  end

  # TODO validate_on_create1 переименовать, убрав 1
  def validate_on_create
    inv = AzInvitation.find(:all, :conditions => {:email => self.email, :invitation_type => self.invitation_type})
    if inv != nil
      if inv.size > 0
        errors.add_to_base("User with given email already has invitation")
      end
    end

    if self.invitation_type == 'company'
      puts "user_id = " + self.user_id.to_s
      puts "az_company_id = " + self.invitation_data.to_s
      empl = AzEmployee.find(:first, :conditions => { :az_user_id => self.user_id, :az_company_id => self.invitation_data })
      puts "empl = "
      puts empl.inspect
      company = AzCompany.find(self.invitation_data)
      if company && company.ceo.email == self.email
        errors.add_to_base("Пользователь с таким email уже работает в компании \"#{company.name}\"")
      end
      if empl != nil
        errors.add_to_base("Пользователь с таким email уже работает в компании \"#{company.name}\"")
      end
    end

    if AzUser.find_by_email(self.email) && self.invitation_type == 'site'
      errors.add_to_base("User with given email already has account on this site")
    end
  end
end


def ar_owner_ceo_id
  if invitation_data == 'site'
    return -1
  end
  cmp = AzCompany.find(invitation_data)
  if cmp == nil
    return -1
  end

  return cmp.ceo_id
end