# == Schema Information
#
# Table name: comments
#
#  id             :bigint           not null, primary key
#  message        :text
#  application_id :bigint
#  user_id        :bigint
#  stage_id       :bigint
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_comments_on_application_id  (application_id)
#  index_comments_on_stage_id        (stage_id)
#  index_comments_on_user_id         (user_id)
#



class Comment < ApplicationRecord
  require 'utils'
  belongs_to :user
  belongs_to :application
  belongs_to :stage

  validates :message, :presence => true

end
