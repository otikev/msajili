module SpecTestHelper
  def login_admin(package)
    if package == Package::FREE
      company = create(:company)
    elsif package == Package::ON_DEMAND
      company = create(:company,:on_demand_package)
    elsif package == Package::PREMIUM
      company = create(:company,:premium_package)
    end

    admin = company.get_admins.first
    login(admin,true)
  end
  
  def login_recruiter
    company = create(:company)
    recruiter = company.get_recruiters.first
    login(recruiter,false)
  end
  
  def login_applicant
    applicant = create(:applicant)
    login(applicant,false)
  end
  
  def login(user,admin)
    cookies[:auth_token] = user.auth_token 
    if admin
      cookies[:as_admin] = 'true'
    end
  end
  
  def current_user
    user = User.find_by_auth_token!(cookies[:auth_token])
    if user
      if cookies[:as_admin] and cookies[:as_admin] == 'true'
        user.as_admin = true
      else
        user.as_admin = false
      end
    else
      cookies.delete(:auth_token)
      cookies.delete(:as_admin)
    end
    user
  end
end