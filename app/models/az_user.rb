require 'rubygems'
require 'digest/sha1'

class AzUser < ActiveRecord::Base
  using_access_control

  #attr_accessor :guest_project_ids

#  @@open_registartion = false

#  def self.set_registration_open(reg)
#    # Нужно для совершения миграций и тестов! А именно добавления первого юзера
#    @@open_registartion = reg
#  end


#  def self.registration_open?
#    @@open_registartion
#  end

  include Authentication
  include Authentication::ByPassword
  #include Authentication::ByCookieToken

  # TODO validators shiuld be same as redmine validators!!!

  validates_presence_of     :login
  validates_length_of       :login,    :within => 3..30
  validates_uniqueness_of   :login
  validates_format_of       :login,    :with => Authentication.login_regex, :message => Authentication.bad_login_message

  #validates_format_of       :name,     :with => Authentication.name_regex,  :message => Authentication.bad_name_message, :allow_nil => false
  #validates_length_of       :name,     :maximum => 100

  #validates_format_of       :lastname, :with => Authentication.name_regex,  :message => Authentication.bad_name_message, :allow_nil => false
  #validates_length_of       :lastname, :maximum => 100

  validates_presence_of     :email
  #validates_length_of       :email,    :within => 6..100 #r@a.wk
  validates_uniqueness_of   :email
  #validates_format_of       :email,    :with => Authentication.email_regex, :message => Authentication.bad_email_message

  # REDMINE
  validates_presence_of :name,  :lastname
  validates_format_of   :login, :with => /^[a-z0-9_\-@\.]*$/i
  validates_format_of   :name,  :lastname, :with => /^[\w\s\'\-\.]*$/i
  validates_length_of   :name,  :lastname, :maximum => 30
  validates_format_of   :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i
  validates_length_of   :email, :maximum => 60
  validates_length_of   :password, :minimum => 6, :allow_nil => true

  validates_length_of   :new_password, :minimum => 6, :allow_nil => true
  validates_length_of   :new_password_confirmation, :minimum => 6, :allow_nil => true

  #has_many :works
  #has_many :owned_projects,         :class_name => "AzProject",       :foreign_key => 'owner_id'
  #has_many :created_projects,       :class_name => "AzProject",       :foreign_key => 'author_id'
  #has_many :created_blocks,         :class_name => "AzProjectBlock",  :foreign_key => 'author_id'
  #has_many :participated_projects,  :through => :works, :source => :project
  has_many :az_contacts, :foreign_key => 'my_id'
  has_many :az_subscribtions

  has_many :az_subscribtion_categories, :through => :az_subscribtions, :source => :az_subscribtion_category

  has_one :az_register_confirmation

  has_many :az_companies, :foreign_key=>'ceo_id', :dependent => :destroy
  has_many :employments, :class_name => 'AzEmployee', :foreign_key=>'az_user_id', :conditions => {:disabled => false}
  has_many :disabled_employments, :class_name => 'AzEmployee', :foreign_key=>'az_user_id', :conditions => {:disabled => true}
  has_many :works, :through => :employments, :source => :az_company
  has_many :disabled_works, :through => :disabled_employments, :source => :az_company

  attr_accessor :hash_str
  attr_accessor :invited_to_company

  

  #has_and_belongs_to_many   :contacts, :class_name=>'User', :join_table => "contacts", :foreign_key => 'my_id', :association_foreign_key => 'contact_id'

  # HACK HACK HACK -- how to do attr_accessible from here?
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :login, :email, :name, :lastname, :password, :password_confirmation, :roles
  attr_accessor :old_password, :new_password, :new_password_confirmation

  has_many :az_guest_links
  has_many :az_user_logins, :limit => 2, :order => "created_at DESC"
  has_many :all_logins, :order => "created_at DESC", :class_name => "AzUserLogin",  :foreign_key => 'az_user_id'

#  if @@open_registartion
#    acts_as_captcha #:base => "base error when captcha fails", :field => "field error when captcha fails"
#  end

  validate :validate_on_update, on: :update

  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  #
  # uff.  this is really an authorization, not authentication routine.
  # We really need a Dispatch Chain here or something.
  # This will also let us return a human error message.
  #
  def self.authenticate(login, password)
    u = find_by_login(login) # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  def self.authenticate_by_guest_link(link_hash)
    letters = 'abcdefghijklmnopqrstuvwxyz01234567890'

    str_lenght = 24
    str = ""
    str_lenght.times do
      str << letters[rand(letters.size)]
    end

    #self.set_registration_open(true)
    usr = AzUser.new(:login =>str, :roles => [:visitor], :password=>str, :password_confirmation => str, :email => "#{str}@foo.com", :name => 'gogi', :lastname => 'didu')
    usr.save!
    #self.set_registration_open(false)
    return usr
  end


  # Start of code needed for the declarative_authorization plugin
  #
  # Roles are stored in a serialized field of the User model.
  # For many applications a separate UserRole model might be a
  # better choice.
  serialize :roles, Array

  # The necessary method for the plugin to find out about the role symbols
  # Roles returns e.g. [:admin]
  def role_symbols
    @role_symbols ||= (roles || []).map {|r| r.to_sym}
  end
  # End of declarative_authorization code

  # for ChangeAnalyzer: ensure that role_symbols is cloned
  def clone
    a_clone = super
    a_clone.send(:instance_variable_set, :@role_symbols, @role_symbols.clone) if @role_symbols
    a_clone
  end

  def validate_on_update
    puts "validate_on_update ============================================================== 1"
    puts self.inspect
    puts "================================================================================= 2"
    puts "new_password = #{self.new_password}"
    puts "new_password_confirmation = #{self.new_password_confirmation}"
    puts "old_password = #{self.old_password}"
    puts "validate_on_update ============================================================== 3"
    puts AzUser.inspect

    if self.new_password != nil || self.new_password_confirmation != nil || self.old_password != nil
      #puts "1"
      if authenticated?(self.old_password)
        #puts "2"
        if self.new_password != self.new_password_confirmation
          #puts "3"
          errors.add(:base, "Пароли не совападают.")
          errors.add(:new_password, "Новый пароль должен совпадать с подтверждением.")
          errors.add(:new_password_confirmation, "Подтверждение должно совпадать с новым паролем.")
        elsif self.new_password.empty?
          errors.add(:new_password, "Необходимо указать новый пароль.")
          errors.add(:new_password_confirmation, "Необходимо указать подтверждение для нового пароля.")
        end
      else
        #puts "4"
        errors.add(:base, "Неверный старый пароль.")
        errors.add(:old_password, "Неверный старый пароль.")
      end
    end
    puts "validate_on_update ============================================================== 4"
  end

  def validate_on_create
#    if !AzUser.registration_open?
#      invitation = AzInvitation.find(:first, :conditions => {:hash_str => self.hash_str})
#      if invitation == nil
#        errors.add(:base, "Your invitation not found. Sorry.")
#        errors.add(:hash_str, "приглашение не найдено")
#      else
#        if invitation.email != self.email
#          errors.add(:base, "You enter email differs from email where invitation was sent.")
#          errors.add(:email, "приглашение было выслано на другой адрес")
#        end
#      end
#
#    end
  end

  def my_works
    #w1 = az_companies.collect { |c| c.id }
    #w2 = works.collect { |c| c.id }
    #w1.concat(w2)
    #w1.uniq!
    #return AzCompany.find(w1)
    return AzCompany.find(my_works_ids)
  end

  def my_works_ids
    w1 = az_companies.collect { |c| c.id }
    w2 = works.collect { |c| c.id }
    w1.concat(w2)
    w1.uniq!
    return w1
  end

  def can_clone?(entity)
    # На данный момент клонировать к себе в компанию может толко директор. 
    # Не зависимо от того что именно за entity нужно клонировать
    return !az_companies.empty?
  end

  #def my_managed_project_ids
  #  return [551]
  #end

  def add_contact_by_login(login)
    user = AzUser.find_by_login(login)

    contact = nil

    if user != nil
      contact = AzContact.new
      contact.my_id = self.id
      contact.az_user = user
    end
    return contact
  end

  def get_my_invitations_to_site
    return AzInvitation.find(:all, :conditions => {:invitation_type => 'site', :invitation_data => self.id, :user_id => nil})
  end

  def get_my_invited_users
    #return AzInvitation.find(:all, :conditions => {:invitation_type => 'site', :invitation_data => self.id, :user_id_not => nil})
    conditions = [" invitation_data = ? AND invitation_type = 'site' AND user_id IS NOT NULL ", self.id]
    #hash_conditions = {:invitation_type => 'site', :invitation_data => self.id }
    #conditions = AzInvitation.merge_conditions(hash_conditions) + ' AND user_id NOT NULL '
    #products = Product.find(:all, :conditions => conditions)
    return AzInvitation.find(:all, :conditions => conditions)
  end

  def get_invitations_to_get_work
    return AzInvitation.find(:all, :conditions => {:invitation_type => 'company', :user_id => self.id, :rejected => nil})
  end

  def guest_project_ids
    if az_guest_links && az_guest_links.size > 0
      return [az_guest_links[0].az_project.id]
    end
    return []
  end

  def to_s
    return "User id: #{id} #{login} (#{name} #{lastname})"
  end

  private
  def password_not_nil
    ret = self.new_password != nil || self.new_password_confirmation != nil || self.old_password != nil
    puts self.new_password != nil
    puts self.new_password_confirmation != nil
    puts self.old_password != nil
    puts "password_not_nil = #{ret}"
    return ret
  end


end
