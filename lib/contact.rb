class Contact
  require 'utils'
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming
  
  attr_accessor :name, :email, :subject, :message
  
  validates :name, :presence => true
  validates :email, :presence => true
  validates :message, :presence => true
  validates_length_of :message, :maximum => 500
  validates_format_of :email, :with => Utils::VALID_EMAIL_REGEX, :multiline => true
  
  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end
  
  def persisted?
    false
  end
end