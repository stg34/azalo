class AzEmployee < OwnedActiveRecord
  # TODO Почему ActiveRecord::Base, а не OwnedActiveRecord ???

  belongs_to :az_company
  belongs_to :az_user

  has_many :az_participants, :dependent => :destroy
  has_many :projects, :through => :az_participants, :source => 'az_project', :order => :position, :uniq => true

  validates_presence_of     :az_user
  validates_presence_of     :az_company

  validate :validate1
  # validate :validate_on_create1, on: :create

  def validate_on_create1
    empl = AzEmployee.find(:first, :conditions => { :az_user_id => self.az_user_id, :az_company_id => self.az_company_id })
    if empl != nil
      errors.add(:base, "User #{self.az_user.name} already works in #{self.az_company.name}")
    end
  end

  def validate1
    validate_employee_quota
    validate_ceo_id_not_disabled
    validate_on_create1 if new_record?
  end

  def validate_employee_quota
    if az_company.employee_quota_reached
      if new_record?
        puts 'Error 1 new employee'
        errors.add(:base, "Error! Employee quota exceed")
      else
        puts 'Error 2 new employee'
        puts 'existing employee'
        old_emplayee = AzEmployee.find(self.id)
        if old_emplayee.disabled == true and self.disabled == false
          puts 'Error 2.1 new employee ----------------'
          errors.add(:base, "Error! Employee quota exceed")
        end
      end
    end
  
  end

  def validate_ceo_id_not_disabled
    if !new_record? && self.disabled == true && self.az_user == self.az_company.ceo
      errors.add(:base, "CEO cannot be disabled")
    end
  end

  def self.get_by_company(company)
    return company.az_employees
  end

  def self.get_by_companies(companies)
    items = {}
    companies.each do |company|
      items[company] = get_by_company(company)
    end
    return items
  end

  def to_s
    return "Employee id: #{self.id} #{self.az_user.login} (#{self.az_user.id}) (#{self.az_company.name})"
  end

  def enable
    self.disabled = false
    save
  end

  def disable
    self.disabled = true
    save
  end

end
