class Role
  require 'utils'

  def self.role_name(role)
    name = ''
    if role == self.admin
      name = 'admin'
    elsif role == self.recruiter
      name = 'recruiter'
    elsif role == self.applicant
      name = 'applicant'
    end
    name
  end
  
  def self.admin
    return 1
  end
  
  def self.recruiter
    return 2
  end
  
  def self.applicant
    return 3
  end
end
