# == Schema Information
#
# Table name: interviews
#
#  id              :bigint           not null, primary key
#  start_time      :datetime
#  end_time        :datetime
#  location        :string
#  additional_info :text
#  comments        :text
#  user_id         :bigint
#  application_id  :bigint
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_interviews_on_application_id  (application_id)
#  index_interviews_on_user_id         (user_id)
#


class Interview < ApplicationRecord
  belongs_to :user
  belongs_to :application

  validates :application, :presence => true
  validates :user, :presence => true
  validates :start_time, :presence => true
  validates :end_time, :presence => true

  def self.events(params,view_context,current_user)
    start = params[:start]
    end_date = params[:end]
    interviews = Interview.includes(:user,:application).joins(:user).where('users.company_id = ? and start_time >= ? and start_time <= ?',current_user.company_id,start,end_date)
    events = []
    interviews.each do |i|
      events.push(EventObject.new({id:i.id,
                                   title:i.application.user.first_name+' '+i.application.user.last_name,
                                   allDay: false,
                                   start: i.start_time,
                                   end: i.end_time,
                                   url: view_context.calendar_path(application_id: i.application.id)}))
    end
    events
  end
end
