#encoding: utf-8
module Interkassa
  module InterkassaHelper
    # Displays a form to send a payment request to Interkassa
    #
    # You can either pass in a block, that SHOULD render a submit button (or not, if you plan to submit the form otherwise), or
    # let the helper create a simple submit button for you.
    #
    # ik_request - an instance of Interkassa::Request
    # options - currently accepts two options
    #   id - the ID of the form being created (`interkassa_form` by default)
    #   title - text on the submit button (`Pay with Interkassa` by default); not used if you pass in a block
    def interkassa_button(ik_request, options={}, &block)
      id = options.fetch(:id, 'interkassa_form')
      title = options.fetch(:title, 'Pay with Interkassa')
      content_tag(:form, :id => id,:name=>id, :action => Interkassa::INTERKASSA_ENDPOINT_URL, :method => :post) do
        result = hidden_field_tag(:ik_shop_id, ik_request.ik_shop_id)+
            hidden_field_tag(:ik_payment_amount, ik_request.ik_payment_amount)+
            hidden_field_tag(:ik_payment_id, ik_request.ik_payment_id)+
            hidden_field_tag(:ik_payment_desc, ik_request.ik_payment_desc)+
            hidden_field_tag(:ik_paysystem_alias, ik_request.ik_paysystem_alias)+
            hidden_field_tag(:ik_baggage_fields, ik_request.ik_baggage_fields)+
            hidden_field_tag(:ik_success_url, ik_request.ik_success_url)+
            hidden_field_tag(:ik_success_method, ik_request.ik_success_method)+
            hidden_field_tag(:ik_fail_url, ik_request.ik_fail_url)+
            hidden_field_tag(:ik_fail_method, ik_request.ik_fail_method)+
            hidden_field_tag(:ik_status_url, ik_request.ik_status_url)+
            hidden_field_tag(:ik_status_method, ik_request.ik_status_method);
        if block_given?
          result += yield
        else
          result += submit_tag(title, :name => nil)
        end
        result
      end
    end
  end
end