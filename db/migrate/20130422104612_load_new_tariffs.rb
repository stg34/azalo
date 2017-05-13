class LoadNewTariffs < ActiveRecord::Migration
  def self.up
    tariff_params = [{:name => 'Бесплатный',     :price => 0,  :quota_employees => 0,  :quota_private_projects => 0 },
                     {:name => 'Фрилансер',      :price => 4,  :quota_employees => 0,  :quota_private_projects => 2 },
                     {:name => 'Студия',         :price => 15, :quota_employees => 5,  :quota_private_projects => 5 },
                     {:name => 'Хорошая студия', :price => 30, :quota_employees => 10, :quota_private_projects => 10 }]
    tariff_params.each do |tp|
      tariff = AzTariff.find(:first, :conditions => {:tariff_type => 2, :name => tp[:name]})
      tp.each_pair do |k, v|
        tariff[k] = v
      end
      tariff.save
    end
    
  end

  def self.down
    
  end
end

