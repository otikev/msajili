class Package

  FREE = 1
  ON_DEMAND = 2
  PREMIUM = 3

  FREE_PRICE = 0
  ON_DEMAND_PRICE = 1999
  PREMIUM_PRICE = 9999

  ON_DEMAND_USER_COUNT = 3

  PREMIUM_TRIAL_DAYS_COUNT = 30

  FREE_CANDIDATE_COUNT = 50

  def self.package_name(package)
    name =''
    if package == FREE
      name='Free'
    elsif package == ON_DEMAND
      name = 'On-Demand'
    elsif package == PREMIUM
      name = 'Premium'
    end
    name
  end
end
