class PesapalController < ActionController::Base

  def callback
    puts '**************************************'
    puts 'pesapal callback'
    puts '**************************************'
    pesapal_merchant_reference = params[:pesapal_merchant_reference]
    pesapal_transaction_tracking_id = params[:pesapal_transaction_tracking_id]
    payment = Payment.where(:pesapal_merchant_reference => pesapal_merchant_reference).first
    if payment
      payment.pesapal_transaction_tracking_id = pesapal_transaction_tracking_id
      if payment.save
        payment.check_status
        flash[:success] = 'Your payment has been received and is being processed.'
      else
        flash[:danger] = 'Something went wrong, please contact us.'
      end
    end
    redirect_to dashboard_path
  end

  def ipn
    pesapal_notification_type = params[:pesapal_notification_type]
    pesapal_merchant_reference = params[:pesapal_merchant_reference]
    pesapal_transaction_tracking_id = params[:pesapal_transaction_tracking_id]

    pesapal = Pesapal::Merchant.new
    response_to_ipn = pesapal.ipn_listener(pesapal_notification_type,
                                           pesapal_merchant_reference,
                                           pesapal_transaction_tracking_id)

    payment = Payment.where(:pesapal_merchant_reference => pesapal_merchant_reference,
                                     :pesapal_transaction_tracking_id => pesapal_transaction_tracking_id).first
    if payment
      payment.check_status
    end
    render :text => response_to_ipn
  end


end
