require 'will_paginate' # TDOD Без этого не стартует rake azalo:db_info. WTF???
class AzMessage < ActiveRecord::Base

  validates_presence_of     :email
  validates_format_of       :email,    :with => Authentication.email_regex, :message => Authentication.bad_email_message
  #validates_format_of   :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i


  validates_presence_of     :subject

  validates_presence_of     :message, :message => 'не может быть пустым'

  def get_status1_color
    return Statuses1[self.status1][:color]
  end

  def get_status2_color
    return Statuses2[self.status2][:color]
  end

  def get_status3_color
    return Statuses3[self.status3][:color]
  end

  Statuses1 = [{ :id => 0, :name => '---',           :color => 'lavenderblush'},
               { :id => 1, :name => 'Инвайт',        :color => 'silver'},
               { :id => 2, :name => 'Предложение',   :color => 'cyan'},
               { :id => 3, :name => 'Баг',           :color => 'yellow'},
               { :id => 4, :name => 'Вопрос',        :color => 'lime'}
               ]

  Statuses2 = [{ :id => 0, :name => '---',           :color => 'lavenderblush'},
               { :id => 1, :name => 'Инвайт',        :color => 'silver'},
               { :id => 2, :name => 'Предложение',   :color => 'cyan'},
               { :id => 3, :name => 'Баг',           :color => 'yellow'},
               { :id => 4, :name => 'Вопрос',        :color => 'lime'}
               ]

  Statuses3 = [{ :id => 0, :name => '---',           :color => 'lavenderblush'},
               { :id => 1, :name => 'Важно',         :color => 'red'},
               { :id => 2, :name => 'Нормально',     :color => 'cyan'},
               { :id => 3, :name => 'Не горит',      :color => 'silver'},
               { :id => 4, :name => 'Закрыто',       :color => 'white'}
               ]

  def self.statuses1
    return Statuses1.collect{|s| [s[:name] + " (#{s[:color]})", s[:id]] }
  end

  def self.statuses2
    return Statuses2.collect{|s| [s[:name] + " (#{s[:color]})", s[:id]] }
  end

  def self.statuses3
    return Statuses3.collect{|s| [s[:name] + " (#{s[:color]})", s[:id]] }
  end

  def statuses1
    return AzMessage.statuses1
  end

  def statuses2
    return AzMessage.statuses2
  end

  def statuses3
    return AzMessage.statuses3
  end

  self.per_page = 20

end
