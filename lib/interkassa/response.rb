#encoding: utf-8
require "interkassa/base_operation"
require 'digest/md5'

module Interkassa
  class Response < BaseOperation
    SUCCESS_STATUSES = "success"

    ATTRIBUTES = %w(ik_shop_id ik_payment_amount ik_payment_id ik_paysystem_alias ik_baggage_fields ik_payment_state ik_trans_id ik_currency_exch ik_fees_payer ik_payment_desc ik_payment_timestamp ik_sign_hash)
    SIGN_ATTRIBUTES = %w(ik_shop_id ik_payment_amount ik_payment_id ik_paysystem_alias ik_baggage_fields ik_payment_state ik_trans_id ik_currency_exch ik_fees_payer);
    SPLITER=":"
=begin
    %w(ik_shop_id ik_payment_amount ik_payment_id ik_payment_desc ik_paysystem_alias ik_baggage_fields ik_payment_timestamp ik_payment_state ik_trans_id ik_currency_exch ik_fees_payer ik_sign_hash).each do |attr|
      attr_reader attr
    end
=end

    #Идентификатор магазина зарегистрированного в системе «INTERKASSA» на который был совершен платеж.
    attr_reader :ik_shop_id
    #Сумма платежа, которую заплатил покупатель получить от покупателя (с учетом валюты и курса магазина, настраивается в «Настройки магазина»).
    #Дробная часть отделяется точкой.
    attr_reader :ik_payment_amount
    #В этом поле передается идентификатор покупки в соответствии с системой учета продавца, полученный сервисом с веб-сайта продавца.
    attr_reader :ik_payment_id
    #Описание товара или услуги.
    attr_reader :ik_payment_desc
    #Способ оплаты с помощью которого была произведена оплата покупателем.
    #Возможные значения: rupay, egold, webmoneyz, webmoneyu, webmoneyr, webmoneye, ukrmoneyu, ukrmoneyz, ukrmoneyr, ukrmoneye, liberty, pecunix
    attr_reader :ik_paysystem_alias
    #Это поле, переданное с веб-сайта продавца в «Форме запроса платежа»
    #Пример: email: mail@mail.com, tel: +380441234567
    attr_reader :ik_baggage_fields
    #Дата и время выполнения платежа в UNIX TIMESTAMP формате
    attr_reader :ik_payment_timestamp
    #Состояние (статус) платежа проведенного в системе «INTERKASSA».
    #Принимаемые значения: success / fail. (success – платеж принят, fail – платеж не принят).
    attr_reader :ik_payment_state
    #Номер платежа в системе «INTERKASSA», выполненный в процессе обработки запроса на выполнение платежа сервисом Interkassa Payment Interface. Является уникальным в системе «INTERKASSA».
    attr_reader :ik_trans_id
    #Курс валюты, установленный в «Настройках магазина» в момент создания платежа.
    attr_reader :ik_currency_exch
    #Плательщик комиссии, установленный в «Настройках магазина» в момент создания платежа.
    #Пример: 0 – за счет продавца, 1– за счет покупателя, 2 – 50/50
    attr_reader :ik_fees_payer
    #Контрольная подпись оповещения о выполнении платежа, которая используется для проверки целостности полученной информации и однозначной идентификации отправителя.
    attr_reader :ik_sign_hash

    def initialize(options = {})
      super(options)

      @ik_shop_id = options[:ik_shop_id]
      @ik_payment_amount = options[:ik_payment_amount]
      @ik_payment_id = options[:ik_payment_id]
      @ik_payment_desc = options[:ik_payment_desc]
      @ik_paysystem_alias = options[:ik_paysystem_alias]
      @ik_baggage_fields = options[:ik_baggage_fields]
      @ik_payment_timestamp = options[:ik_payment_timestamp]
      @ik_payment_state = options[:ik_payment_state]
      @ik_trans_id = options[:ik_trans_id]
      @ik_currency_exch = options[:ik_currency_exch]
      @ik_fees_payer = options[:ik_fees_payer]
      @ik_sign_hash = options[:ik_sign_hash]

      validate!
    end

    # Returns true, if the transaction was successful
    def success?
      SUCCESS_STATUSES== self.ik_payment_state
    end

    private
    def validate!

      if check_sum() != self.ik_sign_hash
        raise Interkassa::InvalidResponse
      end

    end

    def check_sum()
     data=""
     self.secret_key = "5GJHrsQWdpWePreh"
     SIGN_ATTRIBUTES.each do |attr|
       data+=self.instance_variable_get("@"+attr).to_s+SPLITER;
     end
     Digest::MD5.hexdigest(data+self.secret_key).upcase
    end

  end
end
