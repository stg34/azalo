class CreateAzProjectStatuses < ActiveRecord::Migration
  def self.up
    create_table :az_project_statuses do |t|
      t.string :name
      t.integer :position
      t.integer :owner_id, :null => false

      t.timestamps
    end

    
    statuses = ['Новый', 'Обсуждается', 'В процессе', 'Тестирование', 'Сдача', 'Сделан']
    companies = AzCompany.all
    
    companies.each do |cmp|
      statuses.each do |st|
        s = AzProjectStatus.create(:name => st, :position => 1, :owner_id => cmp.id)
        s.save
      end
    end

  end

  def self.down
    drop_table :az_project_statuses
  end
end
