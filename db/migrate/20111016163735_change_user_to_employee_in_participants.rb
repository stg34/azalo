class ChangeUserToEmployeeInParticipants < ActiveRecord::Migration
  def self.up
    ActiveRecord::Base.transaction do
      
      add_column :az_participants, :az_employee_id, :integer

      Authorization.current_user = AzUser.find_by_login('admin')

      i = 0
      participants = AzParticipant.all
      void_projects = {}

      no_employee_errors = []
      invalid_conversion_errors = []

      participants.each do |participant|

        if participant.az_project == nil
          puts "Нет проекта с ID = #{participant.az_project_id}"
          u = AzUser.find(participant.az_user_id)
          void_projects[participant.az_project_id] = u.login
          participant.destroy
          next
        end

        # Определяем компанию, которой принадлежит проект
        company = AzCompany.find(participant.az_project.owner.id)

        # Ищем работнтка в этой компании который имеет ID юзера как и participant
        employees = AzEmployee.find(:all, :conditions => {:az_company_id => participant.az_project.owner.id, :az_user_id => participant.az_user_id})
        employee = nil
        if employees.size == 0
          u = AzUser.find(participant.az_user_id)
          str = "ERROR - NO EMPLOYEE for company #{company.name}(#{company.id}) and user #{u.login}(#{u.id})"
          no_employee_errors << str
          puts str
        else
          if employees.size > 1
            u = AzUser.find(participant.az_user_id)
            str = "TOO MANY EMPLOYEES for company #{company.name}(#{company.id}) and user #{u.login}(#{participant.az_user_id})"
            no_employee_errors << str
            puts str
          end
          employee = employees[0]
          participant.az_employee_id = employee.id
          participant.save!
        end

        e = AzEmployee.find(participant.az_employee_id)
        u = AzUser.find(participant.az_user_id)
        puts "#{i} user #{u.login}(#{participant.az_user_id})"
        if participant.az_user_id != e.az_user.id
          invalid_conversion_errors << "ERROR #{i} old user #{participant.az_user_id} new user #{e.az_user.id}"
        end
        i += 1
      end

      puts void_projects.inspect

      puts no_employee_errors.inspect
      puts invalid_conversion_errors.inspect

      #change_column :az_participants, :az_employee_id, :null => false
      change_column :az_participants, :az_employee_id, :integer, :null => false

      add_index :az_participants, :az_project_id
      add_index :az_participants, :az_employee_id
      add_index :az_participants, :owner_id

      remove_column :az_participants, :az_user_id

    end

  end

  def self.down

    ActiveRecord::Base.transaction do

      Authorization.current_user = AzUser.find_by_login('admin')

      add_column :az_participants, :az_user_id, :integer

      participants = AzParticipant.all
      participants.each_with_index do |participant, i|
        if participant.az_employee_id != nil
          e = AzEmployee.find(participant.az_employee_id)
          if e == nil
            puts "ERROR!!! Employee not found id=#{participant.az_employee_id}"
          end
          puts "#{i}"
          participant.az_user_id = e.az_user.id
          participant.save!
        end
      end

      remove_column :az_participants, :az_employee_id
      #change_column :az_participants, :az_user_id, :null => false
    end
  end
end
