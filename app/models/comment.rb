# == Schema Information
#
# Table name: comments
#
#  id             :integer          not null, primary key
#  message        :text
#  application_id :integer
#  user_id        :integer
#  stage_id       :integer
#  created_at     :datetime
#  updated_at     :datetime
#



class Comment < ActiveRecord::Base
  require 'utils'
  belongs_to :user
  belongs_to :application
  belongs_to :stage
  
  validates :message, :presence => true
  
end
