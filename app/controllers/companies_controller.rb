class CompaniesController < ApplicationController
  before_action :admin_login_required, :except => [:new,:show,:create]

  def subscribe
    company = @current_user.company
    if request.post?
      company.package = params[:subscribe][:package].to_i
      if company.save
        company.get_token.reset
        company.set_trial
        if company.package == Package::FREE || company.package == Package::ON_DEMAND
          company.unpublish_all_open_jobs
          company.disable_all_recruiters
        end
        flash[:success] = "You have subscribed to the #{Package.package_name(company.package)} package."
      else
        flash[:danger] = Utils.get_error_string(company,'Something went wrong while changing your package.')
      end
      redirect_to dashboard_path
    else
      @package = params[:package].to_i
      if @package > Package::PREMIUM || @package < Package::FREE
        redirect_to dashboard_path
      end

      if @current_user && company.package == Package::ON_DEMAND
        jobs = company.get_token.jobs
        if jobs > 0
          @warning_text = "You have #{jobs} job tokens. If you proceed to change your subscription you will lose these tokens."
        end
      elsif @current_user && company.package == Package::PREMIUM
        token = company.get_token
        if !token.is_expired
          @warning_text = "You have #{token.days_to_expiry} days left on your premium subscription. If you proceed to change your subscription you will lose these days."
        end
      end
    end
  end

  def payments
    company_id = @current_user.company.id
    render :json=> ActiveSupport::JSON.encode(Payment.datatable(company_id,params,view_context))
  end

  def edit
    @company = Company.where( id: params[:id].to_i).first
    if @company.id != @current_user.company.id
      redirect_to dashboardadmin_url
    end
  end
  
  def save
    @company = Company.where( id: params[:company][:id].to_i).first
    if @company.id != @current_user.company.id
      redirect_to dashboardadmin_url and return false
    end
    
    if @company && @company.update_attributes(company_params)
      flash[:success] = 'Company succesfully updated.'
      redirect_to editcompany_url(id: @company.id) and return false
    else
      render 'edit'
    end
  end

  def show
    @company = Company.where( id: params[:id].to_i).first
    if !@company
      redirect_to root_url and return false
    end
  end
  
  def index
    
  end

  def order
    checkout = params[:checkout]
    quantity = checkout[:quantity].to_i
    company = @current_user.company

    if company.package == Package::ON_DEMAND
      unit_price = Package::ON_DEMAND_PRICE
      total = unit_price*quantity
      description = "#{quantity} jobs at #{unit_price} each. Total = Ksh. #{total}"
    elsif company.package == Package::PREMIUM
      unit_price = Package::PREMIUM_PRICE
      total = unit_price*quantity
      description = "#{quantity} months at #{unit_price} each. Total = Ksh. #{total}"
    end

    payment = Payment.new
    payment.description = description
    payment.quantity = quantity
    payment.package = company.package
    payment.company_id = company.id
    payment.status = Payment.status_pending
    payment.total = total

    if payment.save
      pesapal = Pesapal::Merchant.new
      pesapal.order_details = { :amount => total,
                                :description => description,
                                :type => 'MERCHANT',
                                :reference => payment.pesapal_merchant_reference,
                                :first_name => checkout[:first_name],
                                :last_name => 'N/A',
                                :email => checkout[:email],
                                :phonenumber => 'N/A',
                                :currency => 'KES'
      }
      @order_url = pesapal.generate_order_url
    else
      flash[:danger] = 'An error occurred and your form has not been submitted'
      redirect_to checkout_path
    end
  end

  def checkout
    @company = @current_user.company
  end
end
