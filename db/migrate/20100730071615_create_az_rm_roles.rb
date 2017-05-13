class CreateAzRmRoles < ActiveRecord::Migration
  def self.up
    create_table :az_rm_roles do |t|
      t.integer :rm_role_id
      t.string :name

      t.timestamps
    end

    role_names = {'manager' => 'менеджер',
                  'developer' => 'программист',
                  'layouter' => 'верстальщик',
                  'tester' => 'тестер'}

    role_names.each_value do |name|
      if AzRmRole.find_by_name(name) == nil
        r = AzRmRole.create(:name => name)
        r.save
      end
    end

  end

  def self.down
    drop_table :az_rm_roles
  end
end
