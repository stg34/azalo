#encoding: UTF-8
require "interkassa"
class AzPaymentsController < ApplicationController
  
  #layout "main"
  #layout false, :only => :status
  layout "main", :except => :status

  protect_from_forgery :except => :status

  #/intercassa/fail?ik_shop_id=ACE2267E-64E0-0C51-194B-360B482B142C&ik_payment_id=1&ik_paysystem_alias=liqpaycardz&ik_baggage_fields=Пополнение+счета-1&ik_payment_timestamp=1359124067&ik_payment_state=fail&ik_trans_id=IK_10736578
  #/intercassa/status?ik_baggage_fields=1&iik_payment_amount=10
  def make

  #https://azalo.net/az_payments/fail?ik_shop_id=2387CB55-AF97-A83D-8E72-35567C81BAC7&ik_payment_id=74&ik_paysystem_alias=liqpaycardz&ik_baggage_fields=3&ik_payment_timestamp=1367389740&ik_payment_state=fail&ik_trans_id=IK_13198429

  ik_options = {
    :ik_shop_id => "2387CB55-AF97-A83D-8E72-35567C81BAC7",
    :secret_key => "5GJHrsQWdpWePreh",
    :ik_success_url => 'https://azalo.net/az_payments/success',
    :ik_success_method => 'GET',
    :ik_fail_url => 'https://azalo.net/az_payments/fail',
    :ik_fail_method => 'GET',
    :ik_status_url => 'https://azalo.net/az_payments/status',
    :ik_status_method => 'POST',
    :ik_paysystem_alias => ''
  }


    az_company_id = params[:company_id]
    company = AzCompany.find(az_company_id)

    payment = AzPayment.new
    payment.az_company = company
    payment.amount = 0
    payment.save!

    #ik_options = {}

    ik_options[:ik_payment_id] = payment.id
    ik_options[:ik_payment_desc] = 'Пополнение счета'
    ik_options[:ik_baggage_fields] = "#{company.id}"

    @ik_req = Interkassa::Request.new(ik_options)
    
  end

  def status

    # params = {"ik_paysystem_alias"=>"liqpaycardz", 
    #           "ik_payment_timestamp"=>"1367390513", 
    #           "ik_shop_id"=>"2387CB55-AF97-A83D-8E72-35567C81BAC7", 
    #           "ik_payment_amount"=>"0.05", 
    #           "ik_payment_id"=>"75", 
    #           "ik_trans_id"=>"IK_13198676", 
    #           "ik_payment_desc"=>"fafa", 
    #           "ik_currency_exch"=>"1", 
    #           "ik_payment_state"=>"success", 
    #           "ik_fees_payer"=>"1",
    #           "action"=>"status", 
    #           "controller"=>"az_payments", 
    #           "ik_baggage_fields"=>"3", 
    #           "ik_sign_hash"=>"D06E42E105A6700E0D9D7AA7B9418933"}

    pp params
    #params[:ik_payment_id] = 1
    #params[:ik_payment_amount] = 10

    fixed_params = {}
    params.each_pair do |k, v|
      fixed_params[k.to_sym] = v
    end


    params = fixed_params
    pp params
    
    responce = Interkassa::Response.new(params)
    if responce.success?
      balance_transaction = AzBalanceTransaction.new()
      balance_transaction.az_company_id = params[:ik_baggage_fields]
      balance_transaction.amount = params[:ik_payment_amount].to_f
      balance_transaction.description = "Пополнение счета через платежную систему. Сумма: #{params[:ik_payment_amount]}"
      balance_transaction.save!

      # payment = AzPayment.find(:first, :conditions => {:id => params[:ik_payment_id]})
      
      # if payment
        
      #   bt = AzBalanceTransaction.new
      #   bt.amount = amount
      #   bt.az_company_id = payment.az_company_id
      #   bt.description = 'Пополнение счета'
      #   bt.save

      #   payment.amount = params[:ik_payment_amount]
      #   payment.comment = params.to_json
      #   payment.save

      # end

    else
      #TODO
    end
    respond_to do |format|
      format.html { render :text => 'ok' }
    end
  end

  def success
    #pp params
    @payment = AzPayment.find(:first, :conditions => {:id => params[:ik_payment_id]})
    respond_to do |format|
      format.html # success.html.erb
    end
  end

  def fail
    #pp params
    respond_to do |format|
      format.html # fail.html.erb
    end
  end
end
