class AzTariff < ActiveRecord::Base
  has_many :az_companies

  Tariff_common = 1
  Tariff_special = 0
  Tariff_future = 2

  Tariff_types = [['Обычный', Tariff_common],
                  ['Специальный', Tariff_special],
                  ['Будущий', Tariff_future]
                  ]

  def self.tariff_type_name_by_id(type_id)
    h = {}
    Tariff_types.each do |tt|
      h[tt[1]] = tt[0]
    end

    return h[type_id]
  end

  def self.get_user_available_tariffs
    return get_future_tariffs
    return AzTariff.find(:all, :conditions => {:tariff_type => Tariff_common}, :order => 'position')
  end

  def self.get_future_tariffs
    return AzTariff.find(:all, :conditions => {:tariff_type => Tariff_future}, :order => 'position')
  end

  def self.get_free_tariff
    if Rails.env.test?
      return AzTariff.find(:first, :conditions => {:price => 0})
    else
      return AzTariff.find(5)
    end
  end

  def self.get_begin_and_end_of_month_for_moment(moment)
    bom = moment.at_beginning_of_month
    next_month = bom.next_month
    return bom, next_month
  end

  def get_cost_from_moment_till_end_of_month(now)
    bom, eom = AzTariff.get_begin_and_end_of_month_for_moment(now)
    return price * (eom - now)/(eom - bom)
  end

  def self.unlimited_value
    return 999999
  end

end
