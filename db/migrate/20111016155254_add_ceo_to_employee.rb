class AddCeoToEmployee < ActiveRecord::Migration
  def self.up

    ActiveRecord::Base.transaction do
      #add_column :az_variables, :description, :string, :default => ''
      Authorization.current_user = AzUser.find_by_login('admin')
      i = 0
      companies = AzCompany.all
      companies.each do |cmp|
        puts "#{i} #{cmp.name} #{cmp.ceo.login}"
        i += 1
        employees = AzEmployee.find(:all, :conditions => {:az_user_id => cmp.ceo.id, :az_company_id => cmp.id})
        if employees.size == 0
          puts "Ceo employee not found, OK"
          ceo = AzEmployee.new
          ceo.az_company_id = cmp.id
          ceo.az_user_id = cmp.ceo.id
          ceo.owner_id = cmp.id
          ceo.save!
        elsif employees.size == 1
          puts "Ceo employee found, OK"
        else
          puts "TOO MANY EMPLOYEES!!!"
        end

      end
    end
  end

  def self.down
    ActiveRecord::Base.transaction do
      #remove_column :az_variables, :description
    end
  end
end
