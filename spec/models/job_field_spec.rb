# == Schema Information
#
# Table name: job_fields
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  content    :text
#  job_id     :integer
#  created_at :datetime
#  updated_at :datetime
#  position   :integer
#

require 'rails_helper'

RSpec.describe JobField, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
