class AzCompany < ActiveRecord::Base

  validates_uniqueness_of :name
  validates_presence_of   :name
  validates_presence_of   :ceo_id

  belongs_to :ceo, :class_name=>'AzUser', :foreign_key=>'ceo_id'
  belongs_to :az_tariff

  has_many :invitations, :class_name=>'AzInvitation', :foreign_key => 'invitation_data', :conditions => {:invitation_type => 'company'}
  has_many :not_accepted_invitations, :class_name=>'AzInvitation', :foreign_key => 'invitation_data', :conditions => {:invitation_type => 'company'}

  has_many :enabled_employees, :class_name => 'AzEmployee', :conditions => {:disabled => false}
  has_many :az_employees, :dependent => :destroy
  
  has_one :az_test_period
  has_one :az_warning_period

  has_many :az_balance_transactions

  attr_accessor :delete_logo #Чекбокс для удаления логотипа при редактировании юзером своей компании
  attr_accessor :create_default_content_co_create #Чекбокс для создания дефолтного контента, при ручном создании компании админом
  attr_accessor :wo_ceo_co_create #Чекбокс для создания компании без головы, при ручном создании компании админом

  attr_accessor :payment #Сумма пополнения баланса

  has_attached_file :logo, :styles => {:tiny => '48x24', :main => '96x48'}

  validates_attachment_size           :logo, :in => 1..1024.kilobytes, :if => Proc.new { |a| !a.logo_file_name.blank? }
  validates_attachment_content_type   :logo, :content_type => ['image/jpeg', 'image/png', 'image/gif'], :if => Proc.new { |a| !a.logo_file_name.blank? }

  validates_format_of :site, :with => /(^$)|(^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$)/ix

  has_many :projects,         :class_name => "AzProject",     :foreign_key => 'owner_id', :dependent => :destroy
  has_many :private_projects, :class_name => "AzProject",     :foreign_key => 'owner_id', :conditions => {:public_access => false}
  has_many :project_blocks, :class_name => "AzProjectBlock",  :foreign_key => 'owner_id', :dependent => :destroy
  has_many :definitions,    :class_name => "AzDefinition",    :foreign_key => 'owner_id', :dependent => :destroy
  has_many :commons,        :class_name => "AzCommon",        :foreign_key => 'owner_id', :dependent => :destroy
  #has_many :tasks,          :class_name => "AzTask",          :foreign_key => 'owner_id', :dependent => :destroy
  has_many :tr_texts,       :class_name => "AzTrText",        :foreign_key => 'owner_id', :dependent => :destroy
  has_many :validators,     :class_name => "AzValidator",     :foreign_key => 'owner_id', :dependent => :destroy
  has_many :data_types,     :class_name => "AzBaseDataType",  :foreign_key => 'owner_id', :dependent => :destroy
  has_many :az_validators,  :foreign_key => 'owner_id', :dependent => :destroy
  has_many :az_activities,  :foreign_key => 'owner_id', :dependent => :destroy
  

  Refund_tariff_coeff = 0.5

  def available_invitations
    available_invitations_num = self.az_tariff.quota_employees
    available_invitations_num -= self.enabled_employees.size
    waiting_invitations = invitations.select{|i| i.rejected == nil}
    available_invitations_num -= waiting_invitations.size
    available_invitations_num += 1 # Вычеркиваем CEO
    return available_invitations_num
  end

  def self.register_company(ceo, tariff)
    # TODO это должно быть в конструкторе
    test_period = AzTestPeriod.new
    test_period.ends_at = Time.now
    company = self.new
    company.ceo = ceo
    company.name = 'Студия имени ' + ceo.login
    company.az_tariff = tariff
    company.az_test_period = test_period
    company.save
    company.add_employee(ceo)
    company.charge_part_of_fee(Time.now)
    company.create_warning_period
    return company
  end

  def employee_quota_exceed
    #puts 'employee_quota_exceed -------------------------'
    #puts "tariff_name = #{az_tariff.name}"
    #puts "az_tariff.quota_employees = #{az_tariff.quota_employees}"
    #puts "enabled_employees.sizes = #{enabled_employees.size}"
    return az_tariff.quota_employees + 1 + 1 <= enabled_employees.size # +1 CEO, который не входит в квоту
  end

  def employee_quota_reached
    #puts 'employee_quota_reached'
    #puts "#{az_tariff.quota_employees + 1} <= #{enabled_employees.size} = #{az_tariff.quota_employees + 1 <= enabled_employees.size}"
    return az_tariff.quota_employees + 1 <= enabled_employees.size # +1 CEO, который не входит в квоту
  end

  def add_employee(user)
    employee = AzEmployee.new
    employee.az_user = user
    employee.owner = self
    self.az_employees << employee
    self.reload
    return employee
  end

  def delete_employee(employee)
    employee.destroy
    self.reload
  end

  def get_user_employees
    ids = az_employees.collect{ |e| e.az_user_id }
    return AzUser.find(ids.uniq!)
  end

  def get_user_employees_and_ceo
    ids = [ceo_id]
    ids.concat(az_employees.collect{ |e| e.az_user_id })
    ids.uniq!
    return AzUser.find(ids)
  end

  def get_employees
    return az_employees
  end

  def get_employee_by_user(user)
    e1 = az_employees.select{|e| e.az_user_id == user.id}.first
    return e1
  end

  def create_default_content(force = false)
    if self.updated_from_seeds != nil && !force
      return false
    end

    company = self
    entities_to_copy = [AzTrText, AzProjectBlock]
    #entities_to_copy = [AzTask, AzTrText, AzProjectBlock, AzProject]
    entities_to_copy.each do |e|
      e.get_seeds.each do |r|
        r.make_copy(company)
      end
    end
   
    AzValidator.get_seeds.each do |e|
      e.make_copy_validator(company, nil)
    end

    AzStructDataType.get_seeds.each do |e|
      e.make_copy_data_type(company, nil)
    end

    AzDefinition.get_seeds.each do |e|
      e.make_copy_definition(company, nil)
    end

    AzCommon.get_seeds.each do |e|
      e.make_copy_common(company, nil)
    end

#    AzStructDataType.get_seeds.each do |s|
#      s.make_copy(company, nil)
#    end

    self.updated_from_seeds = Time.now
    self.save!
    return true
  end

  def remove_default_content

    entities_to_remove = [AzDefinition, AzCommon, AzProjectBlock, AzProject, AzStructDataType, AzValidator]
    entities_to_remove.each do |e|
      e.get_seeds.each do |r|
        to_remove = e.find(:all, :conditions=>{:copy_of => r.id, :owner_id => self.id})
        to_remove.each do |tr|
          tr.destroy
        end
      end
    end

    return true
  end

  def get_disk_usage
    ret_i = ActiveRecord::Base.connection.select_one("SELECT sum(image_file_size) FROM az_images WHERE owner_id=#{self.id}")
    ret_d = ActiveRecord::Base.connection.select_one("SELECT sum(source_file_size) FROM az_design_sources WHERE az_design_id in(SELECT id FROM az_designs WHERE owner_id=#{self.id})")
    return Integer(ret_i.to_a[0][1]) + Integer(ret_d.to_a[0][1])
  end

  def get_active_projects_count
    return AzProject.get_active_by_company(self).size
  end

  def private_project_quota_exceeded
    puts "private_project_quota_exceeded --- private_projects.size = #{private_projects.size}"
    if (az_tariff.quota_private_projects - private_projects.size) < 0
      puts 'private_project_quota_exceeded!!!'
      return true
    end
    return false
    #return az_tariff.quota_private_projects == 0
  end

  def private_project_quota_reached
    puts "private_project_quota_exceeded --- private_projects.size = #{private_projects.size}"
    if (az_tariff.quota_private_projects - private_projects.size) <= 0
      puts 'private_project_quota_exceeded!!!'
      return true
    end
    return false
    #return az_tariff.quota_private_projects == 0
  end


  def disk_quota_exceeded
    return get_disk_usage > az_tariff.quota_disk
  end

  def self.create_company_with_content
    free_companies_owner = AzUser.find_by_login('admin')
    timestamp = Time.now.to_f
    company = AzCompany.new(:name => "FOOBAR-#{timestamp}")
    company.ceo = free_companies_owner
    company.az_tariff = AzTariff.get_free_tariff
    ret = company.save
    if ret
        company.create_default_content
        return company
    end
    return nil
  end

  def self.get_company_wo_ceo
    free_companies_owner = AzUser.find_by_login('admin')
    AzCompany.find(:first, :conditions => [" updated_from_seeds is not null and ceo_id = #{free_companies_owner.id} and name like ?", 'FOOBAR%'])
  end

  def self.get_all_companies_wo_ceo
    free_companies_owner = AzUser.find_by_login('admin')
    AzCompany.find(:all, :conditions => [" ceo_id = #{free_companies_owner.id} and name like ?", 'FOOBAR%'])
  end

  def get_balance
    AzBalanceTransaction.sum(:amount, :conditions => {:az_company_id => self.id})
  end

  def charge_part_of_fee(from)

    #puts "------------- charge_part_of_fee ------------------- #{self.name} (#{self.id})"
    #puts "tariff #{self.az_tariff.name} price: #{self.az_tariff.price}"
    #puts self.az_tariff.price
    if self.az_tariff.price <= 0
      return
    end
    #puts "------------- charge_part_of_fee ------------------- 2"

    if self.az_test_period == nil && self.az_tariff.price > 0
      test_period = AzTestPeriod.new
      test_period.ends_at = Time.now + AZ_TEST_PERIOD
      self.az_test_period = test_period
      return
    end

    #puts "------------- charge_part_of_fee ------------------- 3"

    AzCompany.transaction do
      
      if test_period_finished
        if az_test_period.state == AzTestPeriod::Part_of_fee_not_charged
          az_test_period.state = AzTestPeriod::Part_of_fee_charged
          az_test_period.save
        else
          return
        end
      else
        return
      end

      bom, eom = AzTariff.get_begin_and_end_of_month_for_moment(from)
      fee = self.az_tariff.get_cost_from_moment_till_end_of_month(from)

      invoice = AzInvoice.new
      bill = AzBill.new
      bt = AzBalanceTransaction.new

      bill.fee = -fee
      bill.description = "Оплата по тарифу #{self.az_tariff.name} за период с #{from} по #{eom}"
      
      #bill.az_invoice = invoice
      invoice.az_bills << bill

      bt.amount = bill.fee
      bt.az_company = self
      bt.description = bill.description
      bt.az_invoice = invoice
      invoice.save
      bt.save
      self.save
    end


  end

  def charge_fee

    #puts "------------- charge_fee ------------------- #{self.name} (#{self.id})"

    if self.az_tariff.price <= 0
      return
    end

    if self.get_locked
      return
    end

    invoice = AzInvoice.new
    bill_1 = AzBill.new
    bt = AzBalanceTransaction.new

    bill_1.fee = -self.az_tariff.price
    bill_1.description = "Оплата по тарифу #{self.az_tariff.name}"

    if test_period_finished

      #puts "------------- charge_fee ------------------- 2"

      AzCompany.transaction do
        bt.az_invoice = invoice
        invoice.save

        bill_1.az_invoice = invoice

        invoice.az_bills << bill_1

        bt.amount = bill_1.fee
        bt.az_company = self
        bt.description = "Оплата по тарифу #{self.az_tariff.name}"
        bt.save
        self.save
        if get_balance < 0
          create_warning_period
        end
      end
    end

  end

  def change_tariff(new_tariff)

    if self.az_test_period == nil && new_tariff.price > 0
      test_period = AzTestPeriod.new
      test_period.ends_at = Time.now + AZ_TEST_PERIOD
      self.az_test_period = test_period
    end

    old_tariff = self.az_tariff

    if self.az_test_period && self.az_test_period.state == AzTestPeriod::Part_of_fee_not_charged && new_tariff.price > 0 && old_tariff.price == 0
      self.az_test_period.state = AzTestPeriod::Part_of_fee_charged
      self.az_test_period.save
    end
    
    now = Time.now

    new_tariff_cheaper = old_tariff.price > new_tariff.price

    if new_tariff_cheaper
      old_cost = (old_tariff.get_cost_from_moment_till_end_of_month(now)*100).round/100.0 * Refund_tariff_coeff # 50% возврата
    else
      old_cost = (old_tariff.get_cost_from_moment_till_end_of_month(now)*100).round/100.0
    end
    new_cost = (new_tariff.get_cost_from_moment_till_end_of_month(now)*100).round/100.0

    self.az_tariff = new_tariff
    
    invoice = AzInvoice.new
    bill_1 = AzBill.new
    bill_2 = AzBill.new
    bt = AzBalanceTransaction.new

    bill_1.fee = -old_cost
    if new_tariff_cheaper
      bill_1.description = "Возврат денег за старый тариф"
    else
      bill_1.description = "Возврат денег за старый тариф (#{Refund_tariff_coeff*100}%)"
    end

    bill_2.fee = new_cost
    bill_2.description = "Оплата по новому тарифу"

    if true || test_period_finished
      AzCompany.transaction do
        bt.az_invoice = invoice
        invoice.save

        bill_1.az_invoice = invoice
        bill_2.az_invoice = invoice

        invoice.az_bills << bill_1
        invoice.az_bills << bill_2

        bt.amount = old_cost - new_cost
        bt.az_company = self
        if new_tariff_cheaper
          bt.description = "Пересчет по тарифу. Возврат #{old_cost} (#{Refund_tariff_coeff*100}%) за неиспользованное время по тарифу '#{old_tariff.name}', списание #{new_cost} за аналогичное время по тарифу '#{new_tariff.name}'."
        else
          bt.description = "Пересчет по тарифу. Возврат #{old_cost} за неиспользованное время по тарифу '#{old_tariff.name}', списание #{new_cost} за аналогичное время по тарифу '#{new_tariff.name}'."
        end
        puts bt.description
        bt.save
        self.save
      end
    else
      self.save # Сохраняем новый тариф компании
    end

    if get_balance < 0
      create_warning_period
    else
      destroy_warning_period
    end

    # Если у нас есть приватные проекты, а мы перешли на тариф с кол-вом приватных проектов меньшим чем есть сейчас, дизэйблим часть проектов
    #puts 'change taiff ------------------ check private project quota'
    #puts "private_projects.size = #{private_projects.size}"
    #puts "self.az_tariff.quota_private_projects = #{self.az_tariff.quota_private_projects}"
    #puts "private_projects.size > self.az_tariff.quota_private_projects = #{private_projects.size > self.az_tariff.quota_private_projects}"
    if private_projects.size > self.az_tariff.quota_private_projects
      private_projects_to_disable_num = 0
      disabled_projects_num = 0

      private_projects.each do |prj|
        if prj.is_active?
          private_projects_to_disable_num += 1
          if private_projects.size  - private_projects_to_disable_num <= self.az_tariff.quota_private_projects
            break
          end
        end
      end

      #puts "private_projects_to_disable_num = #{private_projects_to_disable_num}"

      if private_projects_to_disable_num > 0
        private_projects.reverse.each do |prj|
          if prj.is_active?
            disabled_projects_num += 1
            #puts "Disabling project #{prj.id} #{prj.name}"
            prj.update_status(AzProjectStatus.get_frozen_status)
            #puts "Disabled project #{prj.id} #{prj.name}"
          end

          if disabled_projects_num >= private_projects_to_disable_num
            break
          end

        end
      end
    end
    
    

    # Если у нас есть работники, а мы пепешли на тариф с кол-во работников меньшим чем есть сейчас, дизэйблим часть работников
    if employee_quota_exceed
      employees = enabled_employees.sort{|a, b| b.id <=> a.id}
      disabled_employees_num = 0

      employee_to_disable_num = enabled_employees.size - az_tariff.quota_employees - 1

      employees.each do |employee|
        if employee.id != self.ceo.id
          #puts "disabling employee #{employee.id}"
          ret = employee.disable
          #puts "employee.disable result = #{ret}"
          disabled_employees_num += 1
        end
        break if disabled_employees_num >= employee_to_disable_num
      end
      
    end


  end


  # Тнокость!
  # test_period_not_finished не эквивалентно !test_period_finished
  # если у компании вообще отсутвует тестовый период обе функции возвращают false
  def test_period_not_finished
    if self.az_test_period == nil
      return false
    end

    dt = self.az_test_period.ends_at - Time.now
    return self.az_test_period.ends_at >= Time.now
  end

  def test_period_finished
    if self.az_test_period == nil
      return false
    end
    dt = self.az_test_period.ends_at - Time.now
    return self.az_test_period.ends_at < Time.now
  end

  def create_warning_period
    if az_warning_period == nil && get_balance < 0
      wp = AzWarningPeriod.new
      wp.ends_at = Time.now + AZ_WARNING_PERIOD
      self.az_warning_period = wp
      MessageMailer.cash_warning_message(ceo.email,
                                         'Задолженность по оплате услуг сервиса azalo.net',
                                         id, name, "#{ceo.name} #{ceo.lastname}",
                                         get_balance, wp.ends_at).deliver
      MessageMailer.cash_warning_message(Admin_email,
                                         'Задолженность по оплате услуг сервиса azalo.net',
                                         id, name, "#{ceo.name} #{ceo.lastname}",
                                         get_balance, wp.ends_at).deliver

      wp.save!
      #puts "created cash warning for #{self.name} #{self.id}"
    end
  end

  def destroy_warning_period
    self.az_warning_period = nil
    self.save
  end

  def get_locked
    #puts "--- get_locked ---"
    #puts AzWarningPeriod.find(:first, :conditions => {:az_company_id => self.id})
    if az_warning_period == nil
      return false
    end

    if az_warning_period.ends_at < Time.now
      return true
    end

    return false
  end
  
end
