# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Create categories
Category.create(name: 'Accounting')
Category.create(name: 'Administrative')
Category.create(name: 'Agriculture')
Category.create(name: 'Aviation')
Category.create(name: 'Banking & Financial Services')
Category.create(name: 'Customer Service')
Category.create(name: 'Education & Training')
Category.create(name: 'Engineering & Construction')
Category.create(name: 'Healthcare')
Category.create(name: 'Human Resources')
Category.create(name: 'ICT')
Category.create(name: 'Insurance')
Category.create(name: 'Legal')
Category.create(name: 'Logistics')
Category.create(name: 'Public Service')
Category.create(name: 'Sales & Marketing')
Category.create(name: 'Tourism & Hospitality')
Category.create(name: 'Transportation')
Category.create(name: 'Research')
Category.create(name: 'Other')

#Create academic level
AcademicLevel.create([{description: 'Primary school'},{description: 'O level'},{description: 'A level'},{description: 'Undergraduate'},{description: 'Postgraduate'},{description: 'Doctorate'}])