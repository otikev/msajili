# == Schema Information
#
# Table name: interviews
#
#  id              :integer          not null, primary key
#  start_time      :datetime
#  end_time        :datetime
#  location        :string(255)
#  additional_info :text
#  comments        :text
#  user_id         :integer
#  application_id  :integer
#  created_at      :datetime
#  updated_at      :datetime
#


FactoryGirl.define do
  factory :interview do
    date_and_time "2014-10-28 00:12:24"
    location "MyString"
    additional_info "MyText"
    comments "MyText"
  end

end
