class CreateAzEmployees < ActiveRecord::Migration
  def self.up
    create_table :az_employees do |t|
      t.integer :az_user_id
      t.integer :az_company_id
      t.timestamps
    end

    users = AzUser.all
    users.each do |user|
      cmp = AzCompany.new(:ceo_id => user.id)
      cmp.name = 'Студия имени ' + user.login
      cmp.save!
      empl = AzEmployee.new(:az_user_id => user.id, :az_company_id=>cmp.id)
      empl.save!
    end

  end

  def self.down
    drop_table :az_employees
  end
end
