# == Schema Information
#
# Table name: payments
#
#  id                              :bigint           not null, primary key
#  description                     :string
#  quantity                        :integer
#  package                         :integer
#  status                          :integer
#  total                           :integer
#  pesapal_transaction_tracking_id :string
#  pesapal_merchant_reference      :string
#  company_id                      :bigint
#  created_at                      :datetime         not null
#  updated_at                      :datetime         not null
#
# Indexes
#
#  index_payments_on_company_id  (company_id)
#



class Payment < ApplicationRecord
  require 'utils'
  belongs_to :company
  has_one :commission

  validates :company, :presence => true
  validates :description, :presence => true
  validates :quantity, :presence => true
  validates :package, :presence => true
  validate :valid_package
  validate :valid_quantity

  before_create {generate_merchant_reference}

  def self.datatable_all(params,view_context)

    if params[:sSearch]
      phrase = "%#{params[:sSearch]}%".downcase
      payments = Payment.where('(pesapal_merchant_reference ILIKE ?)',phrase).order(:id => :desc).limit(params[:iDisplayLength]).offset(params[:iDisplayStart])
      count = Payment.where('(pesapal_merchant_reference ILIKE ?)',phrase).count
    else
      payments = Payment.order(:id => :desc).load.limit(params[:iDisplayLength]).offset(params[:iDisplayStart])
      count = Payment.all.count
    end

    payment_list = []
    payments.each do |p|
      obj = p.as_json(only:[:description,:quantity])
      obj[:company] = p.company.name
      obj[:status] = status_string_html(p.status)
      obj[:package] = Package.package_name(p.package)
      obj[:reference] = p.pesapal_merchant_reference
      obj[:created_at] = view_context.format_date(p.created_at)

      payment_list.push(obj)
    end

    data = Hash.new
    data['sEcho'] = params[:sEcho]
    data['iTotalRecords'] = count
    data['iTotalDisplayRecords'] = count
    data['aaData'] = payment_list
    return data
  end

  def self.datatable(company_id,params,view_context)
    payments = Payment.where(:company_id => company_id).order(:id => :desc).limit(params[:iDisplayLength]).offset(params[:iDisplayStart])
    count = Payment.where(:company_id => company_id).count

    payment_list = []
    payments.each do |p|
      obj = p.as_json(only:[:description,:quantity])
      obj[:status] = status_string_html(p.status)
      obj[:package] = Package.package_name(p.package)
      obj[:reference] = p.pesapal_merchant_reference
      obj[:created_at] = view_context.format_date(p.created_at)

      payment_list.push(obj)
    end

    data = Hash.new
    data['sEcho'] = params[:sEcho]
    data['iTotalRecords'] = count
    data['iTotalDisplayRecords'] = count
    data['aaData'] = payment_list
    return data
  end

  def self.check_pending_payments
    pending_payments = Payment.where(:status => Payment.status_pending)
    pending_payments.each do |p|
      p.check_status
    end
    pending_payments.count
  end

  def check_status
    if self.status == Payment.status_pending
      pesapal = Pesapal::Merchant.new
      payment_status = pesapal.query_payment_status(self.pesapal_merchant_reference,self.pesapal_transaction_tracking_id)
      #payment_status can be either PENDING, COMPLETED, FAILED or INVALID
      if payment_status
        if payment_status.downcase == 'pending'
          self.status = Payment.status_pending
        elsif payment_status.downcase == 'completed'
          self.status = Payment.status_completed
        elsif payment_status.downcase == 'failed'
          self.status = Payment.status_failed
        elsif payment_status.downcase == 'invalid'
          self.status = Payment.status_invalid
        end
      end
      if self.save
        if self.status == Payment.status_completed
          #Status was pending and is now completed
          provide_service
          set_commission
        end
      end
    end
    self.status
  end

  def self.status_pending
    0
  end

  def self.status_completed
    1
  end

  def self.status_failed
    2
  end

  def self.status_invalid
    3
  end

  def self.status_string_html(status)
    status_str = ''
    if status == status_pending
      status_str = "<p class='btn btn-primary btn-xs'>#{status_string(status)}</p>"
    elsif status == status_completed
      status_str = "<p class='btn btn-success btn-xs'>#{status_string(status)}</p>"
    elsif status == status_failed
      status_str = "<p class='btn btn-danger btn-xs'>#{status_string(status)}</p>"
    elsif status == status_invalid
      status_str = "<p class='btn btn-warning btn-xs'>#{status_string(status)}</p>"
    end
    status_str
  end

  def self.status_string(status)
    status_str = ''
    if status == status_pending
      status_str = 'pending'
    elsif status == status_completed
      status_str = 'completed'
    elsif status == status_failed
      status_str = 'failed'
    elsif status == status_invalid
      status_str = 'invalid'
    end
    status_str
  end

  protected
  def valid_quantity
    errors.add(:base, 'Invalid quantity') if quantity < 1
  end

  def valid_package
    errors.add(:base, 'Invalid package') if package < Package::FREE || package > Package::PREMIUM
  end

  def generate_merchant_reference
    begin
      self[:pesapal_merchant_reference] = "#{Utils.random_upcase_string(3)}-#{Utils.random_upcase_string(3)}-#{Utils.random_upcase_string(3)}"
    end while Payment.exists?(:pesapal_merchant_reference => self[:pesapal_merchant_reference])
  end

  def provide_service
    if self.company.package == Package::ON_DEMAND
        company.get_token.add_jobs(quantity)
    elsif self.company.package == Package::PREMIUM
        company.get_token.extend_expiry(quantity)
    end
  end

  def set_commission
    agent = SalesAgent.where(:referral_id => self.company.referral_id).first
    if !agent
      return
    end

    commission = Commission.where(:payment_id => self.id).first
    if !commission
      commission = Commission.new
    end
    commission.payment_id = self.id
    commission.company_id = self.company.id
    commission.sales_agent_id = agent.id

    if self.package == Package::ON_DEMAND
      sale_amount = self.quantity * Package::ON_DEMAND_PRICE
    elsif self.package == Package::PREMIUM
      sale_amount = self.quantity * Package::PREMIUM_PRICE
    end
    commission_amount = (0.25*sale_amount).to_i
    commission.amount = commission_amount
    commission.save
  end
end
