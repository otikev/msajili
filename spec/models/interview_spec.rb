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


require 'rails_helper'

RSpec.describe Interview, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
