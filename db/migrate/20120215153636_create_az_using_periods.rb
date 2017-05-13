class CreateAzUsingPeriods < ActiveRecord::Migration
  def self.up
    create_table :az_using_periods do |t|
      t.integer :az_company_id, :null => false
      t.string :type
      t.datetime :ends_at, :null => false
      t.integer :state, :null => false, :default => 0

      t.timestamps
    end

    add_index :az_using_periods, [:az_company_id, :type], :uniq => true
    add_index :az_using_periods, :az_company_id
    add_index :az_using_periods, :ends_at
  end

  def self.down
    drop_table :az_using_periods
  end
end
