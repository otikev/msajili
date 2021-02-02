namespace :categories do
  desc 'Create or update categories'
  task :update => :environment do
    create('Media & Publishing')
    create('Hotel & Hospitality')
    create('Academic')
    create('Management')
    create('Telecommunications')
    create('Volunteer')
    create('Security')
    create('NGO')
    update('Tourism & Hospitality','Tourism')
    update('Research','Science & Research')
  end
end

def create(name)
  Rails.logger.debug "create #{name}"
  if !Category.exists?(:name => name)
    Category.create(name: name)
  end
end

def update(old_name,new_name)
  Rails.logger.debug "update #{old_name} to #{new_name}"
  category = Category.where(:name => old_name).first
  if category
    category.update({name: new_name})
  else
    Rails.logger.debug "#{old_name} doesn't exist!"
  end
end