# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Msajili::Application.initialize!

Rails.logger = Logger.new(STDOUT)