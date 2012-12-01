class PaypalController < ApplicationController
  require 'net/http'

  protect_from_forgery :except => :paypal_ipn

  # This will be called when soemone first subscribes
  def sign_up_user(payer_email, plan_id)
    logger.info("sign_up_user (#{payer_email}) #{plan_id}")
    # new "account".. notify servdrop
    # no op
    #Net::HTTP.get("globalchat2.net", "/main/drop_server?email=#{payer_email}")
  end

  # This will be called if someone cancels a payment
  def cancel_subscription(payer_email, plan_id)
    logger.info("cancel_subscription (#{payer_email}) #{plan_id}")
    # acct canceled, destroy server
    Net::HTTP.get("globalchat2.net", "/main/destroy_server?email=#{payer_email}")
  end

  # This will be called if a subscription expires
  def subscription_expired(payer_email, plan_id)
    logger.info("subscription_expired (#{payer_email}) #{plan_id}")
    # wont happen.. no expiry
    Net::HTTP.get("globalchat2.net", "/main/destroy_server?email=#{payer_email}")
  end

  # Called if a subscription fails
  def subscription_failed(payer_email, plan_id)
    logger.info("subscription_failed (#{payer_email}) #{plan_id}")
    # destroy the server
    Net::HTTP.get("globalchat2.net", "/main/destroy_server?email=#{payer_email}")
  end

  # Called each time paypal collects a payment
  def subscription_payment(payer_email, plan_id)
    logger.info("recurrent_payment_received (#{payer_email}) #{plan_id}")
    Net::HTTP.get("globalchat2.net", "/main/drop_server?email=#{payer_email}")
  end

  # process the PayPal IPN POST
  def paypal_ipn

    # use the POSTed information to create a call back URL to PayPal
    query = 'cmd=_notify-validate'
    request.params.each_pair {|key, value| query = query + '&' + key + '=' +
    value if key != 'register/pay_pal_ipn.html/pay_pal_ipn' }

    # FIXME: change to live when ready
    #paypal_url = 'https://www.paypal.com/cgi-bin/webscr'
    logger.info 'using sandbox'
    paypal_url = 'https://www.sandbox.paypal.com/cgi-bin/webscr'
    uri = URI.parse(paypal_url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    http.use_ssl = true
    http.start
    response = http.post(uri.to_s, query)
    http.finish

    item_name = params[:item_name]
    item_number = params[:item_number]
    payment_status = params[:payment_status]
    txn_type = params[:txn_type]
    payer_email = params[:payer_email]
    mc_gross = params[:mc_gross]

    logger.info "payment status: #{payment_status}"
    logger.info "txn_type #{txn_type}"
    logger.info "response #{response.body.to_s}"
    logger.info "gross #{mc_gross}"

    # Paypal confirms so lets process.
    if response && response.body.chomp == 'VERIFIED'

      if txn_type == 'subscr_signup'
        if mc_gross == "5.00"
          sign_up_user(payer_email, item_number)
        else
          render :text => 'ERROR'
          return
        end
      elsif txn_type == 'subscr_cancel'
        cancel_subscription(payer_email, item_number)
      elsif txn_type == 'subscr_eot'
        subscription_expired(payer_email, item_number)
      elsif txn_type == 'subscr_failed'
        subscription_failed(payer_email, item_number)
      elsif txn_type == 'subscr_payment' && payment_status == 'Completed'
        subscription_payment(payer_email, item_number)
      end

      render :text => 'OK'

    else
      render :text => 'ERROR'
    end
  end
end