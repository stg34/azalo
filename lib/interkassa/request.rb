#encoding: utf-8
require "interkassa/base_operation"

module Interkassa
  class Request < BaseOperation
    #Сумма платежа, которую заплатил покупатель получить от покупателя (с учетом валюты и курса магазина, настраивается в «Настройки магазина»).
    #Дробная часть отделяется точкой.
    # ОБЯЗАТЕЛЬНЫЙ
    attr_accessor :ik_payment_amount
    #В этом поле передается идентификатор покупки в соответствии с системой учета продавца, полученный сервисом с веб-сайта продавца.
    # ОБЯЗАТЕЛЬНЫЙ
    attr_accessor :ik_payment_id
    #Описание товара или услуги.
    # ОБЯЗАТЕЛЬНЫЙ
    attr_accessor :ik_payment_desc
    #Способ оплаты с помощью которого была произведена оплата покупателем.
    #Возможные значения: rupay, egold, webmoneyz, webmoneyu, webmoneyr, webmoneye, ukrmoneyu, ukrmoneyz, ukrmoneyr, ukrmoneye, liberty, pecunix
    # ОБЯЗАТЕЛЬНЫЙ
    attr_accessor :ik_paysystem_alias
    #Это поле, переданное с веб-сайта продавца в «Форме запроса платежа»
    #Пример: email: mail@mail.com, tel: +380441234567
    attr_accessor :ik_baggage_fields
    #URL (на интернет-магазине), на который будет переведен покупатель в случае успешного выполнения платежа в сервисе IKI.
    #URL должен иметь префикс "http://" или https:// (полный путь).
    attr_accessor :ik_success_url
    #Метод передачи данных платежа (POST, GET или LINK), который будет использоваться при переходе на Success URL.
    attr_accessor :ik_success_method
    #URL (на интернет-магазине), на который будет переведен покупатель в том случае, если платеж в сервисе IKI не был выполнен по каким-то причинам.
    #URL должен иметь префикс "http://" или https:// (полный путь).
    attr_accessor :ik_fail_url
    #Метод передачи данных платежа (POST, GET или LINK), который будет использоваться при переходе на Fail URL.
    attr_accessor :ik_fail_method
    #URL (на интернет-магазине), на который сервис IKI посылает HTTP GET или POST оповещение о совершении платежа с его детальными реквизитами. Если вы определили метод передачи Status URL (см. ниже) как “OFF”, то он не будет оповещаться сервисом о совершенных платежах.
    attr_accessor :ik_status_url
    #Метод передачи данных платежа (POST, GET или OFF), который будет использоваться при переходе на Status URL.
    #Выберите вариант 'OFF', если вы не желаете использовать Status URL.
    attr_accessor :ik_status_method

    def initialize(options={})
      super(options)

      @ik_payment_amount = options[:ik_payment_amount]
      @ik_payment_id = options[:ik_payment_id]
      @ik_payment_desc = options[:ik_payment_desc]
      @ik_paysystem_alias = options[:ik_paysystem_alias]
      @ik_baggage_fields = options[:ik_baggage_fields]
      @ik_success_url = options[:ik_success_url]
      @ik_success_method = options[:ik_success_method]
      @ik_fail_url = options[:ik_fail_url]
      @ik_fail_method = options[:ik_fail_method]
      @ik_status_url = options[:ik_status_url]
      @ik_status_method = options[:ik_status_method]
    end

    private
      def validate!

        %w(ik_shop_id ik_payment_amount ik_payment_id ik_payment_desc ik_paysystem_alias).each do |required_field|
          raise Interkassa::Exception.new(required_field + ' is a required field') unless self.send(required_field).to_s != ''
        end

        begin
          self.ik_payment_amount = Float(self.ik_payment_amount)
        rescue ArgumentError, TypeError
          raise Interkassa::Exception.new('amount must be a number')
        end

        raise Interkassa::Exception.new('payment_id must only contain digits') unless ik_payment_id.to_s =~ /\A\d*\Z/

        raise Interkassa::Exception.new('amount must be more than 0.01') unless ik_payment_amount >= 0.01
      end

  end
end
