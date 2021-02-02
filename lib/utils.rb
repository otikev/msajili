class Utils
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  VALID_DOMAIN_REGEX = /^((http|https):\/\/)(([a-z0-9-\.]*)\.)?([a-z0-9-]+)\.([a-z]{2,5})(:[0-9]{1,5})?(\/)?$/ix

  def self.is_numeric?(obj)
    return false if obj == nil
    obj.to_s.match(/\A[+-]?\d+?(\.\d+)?\Z/) == nil ? false : true
  end

  def self.print_and_flush(str)
    print str
    $stdout.flush
  end

  def self.get_error_string(model,title)
    error_string = '<br/><ul>'
    model.errors.full_messages.each do |msg|
      error_string << '<li>'+msg+'</li>'
    end
    error_string << '</ul>'
    error_string = title + error_string
    error_string
  end

  def self.url_valid?(url)
    url.match(VALID_DOMAIN_REGEX) == nil ? false : true
  end
  
  def self.random_string(len)
    #generate a random alphanumeric string of the specified length
    chars = ('a'..'z').to_a + ('A'..'Z').to_a + ('0'..'9').to_a
    newpass = ''
    1.upto(len) { |i| newpass << chars[rand(chars.size-1)] }
    return newpass
  end

  def self.random_upcase_string(len)
    #generate a random alphanumeric string of the specified length
    chars = ('A'..'Z').to_a + ('0'..'9').to_a
    newpass = ''
    1.upto(len) { |i| newpass << chars[rand(chars.size-1)] }
    return newpass
  end

  def self.log_info(message)
    Rails.logger.info message
  end
end