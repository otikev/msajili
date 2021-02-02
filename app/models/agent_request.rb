# == Schema Information
#
# Table name: agent_requests
#
#  id         :bigint           not null, primary key
#  first_name :string
#  last_name  :string
#  phone      :string
#  email      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#


class AgentRequest < ApplicationRecord
  require 'utils'
  validates :first_name, :presence => true
  validates :last_name, :presence => true
  validates :phone, :presence => true
  validates :email, presence: true, format: { with: Utils::VALID_EMAIL_REGEX },uniqueness: { case_sensitive: false }

  def self.datatable(params,view_context)
    if params[:sSearch]
      phrase = "%#{params[:sSearch]}%".downcase
      requests = AgentRequest.where('(first_name ILIKE ? or last_name ILIKE ? or email ILIKE ? or phone ILIKE ?)',phrase,phrase,phrase,phrase).order(:id => :desc).limit(params[:iDisplayLength]).offset(params[:iDisplayStart])
      count = AgentRequest.where('(first_name ILIKE ? or last_name ILIKE ? or email ILIKE ? or phone ILIKE ?)',phrase,phrase,phrase,phrase).count
    else
      requests = AgentRequest.order(:id => :desc).load.limit(params[:iDisplayLength]).offset(params[:iDisplayStart])
      count = AgentRequest.all.count
    end

    request_list = []
    requests.each do |r|
      obj = r.as_json(only:[:first_name,:last_name,:email,:phone])
      obj[:created_at] = view_context.format_date(r.created_at)
      if SalesAgent.where(:email => r.email).first == nil
        obj[:action] = view_context.link_to_accept_agent_request(r.id)
      else
        obj[:action] = 'Accepted'
      end

      request_list.push(obj)
    end

    data = Hash.new
    data['sEcho'] = params[:sEcho]
    data['iTotalRecords'] = count
    data['iTotalDisplayRecords'] = count
    data['aaData'] = request_list
    return data
  end
end
