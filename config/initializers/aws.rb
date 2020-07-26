require 'aws-sdk'

S3_OBJ = Aws::S3::Resource.new(region:'eu-west-1',credentials: Aws::Credentials.new(ENV['AWS_ACCESS_KEY_ID'], ENV['AWS_SECRET_ACCESS_KEY']))

#ActionMailer::Base.add_delivery_method :ses, Aws::SES::Resource.new(region:'eu-west-1',credentials: Aws::Credentials.new(ENV['AWS_ACCESS_KEY_ID'], ENV['AWS_SECRET_ACCESS_KEY']))

