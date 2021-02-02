
require 'utils'

namespace :db do
  desc 'Create sample data'
  task :populate => :environment do
    require 'faker'
    env = Rails.env
    puts "Environment is #{env}"
    if env == 'development'
      start_time = DateTime.current
      Rake::Task['db:reset'].invoke
      puts '***************************************************************************************'
      puts 'Populating database with sample data. This operation will take approximately 10 minutes'
      puts '***************************************************************************************'
      make_companies
      make_applicants
      puts '***************'
      puts "Task started at #{start_time.to_s}, ended at #{DateTime.current}."
      puts '***************'
    else
      puts '*************************************************************'
      puts 'This rake task is only meant for the development environment!'
      puts '*************************************************************'
    end

  end
end

def make_job(company_id,user_id,procedure_id)
  job = Job.create!(:title => Faker::Lorem.sentence,
              :deadline => Date.today + rand(5..60),
              :country => 'KE',
              :city => Faker::Address.city,
              :company_id => company_id,
              :category_id => rand(1..Category.all.count),
              :user_id => user_id,
              :procedure_id => procedure_id)

  job_fields = rand(3..4)
  job_fields.times do
    make_job_field(job.id)
  end
  questions = rand(3..10)
  questions.times do
    make_question(job.id)
  end
  make_filter(job.id)

  job.status = Job.status_open
  job.save
end

def make_job_field(job_id)
  JobField.create!(:job_id => job_id,:title => Faker::Lorem.sentence(2),:content => Faker::Lorem.sentence(20))
end

def make_question(job_id)
  question = Question.create!(:content => Faker::Lorem.sentence(5),:job_id => job_id)
  choices_count = rand(0..4)
  if choices_count > 1
    choices_count.times do
      Choice.create!(:content => Faker::Lorem.sentence(1),:question_id => question.id)
    end
  end
end

def make_answers(application_id)
  application = Application.find(application_id)
  questions = application.job.questions
  questions.each do |q|
    answer = q.answers.where(:application_id => application_id).first
    if !answer
      answer = Answer.new
    end

    if q.has_choices
      random = rand(0..1)
      if random == 0
        choice = q.choices.first
      else
        choice = q.choices.last
      end
      answer.set_values(q.id,application_id,choice.id,nil,nil)
      answer.save
    else
      answer.set_values(q.id,application_id,nil,Faker::Lorem.sentence(5),nil)
      answer.save
    end
  end
end

def make_filter(job_id)
  filter = Filter.create!(:title => Faker::Lorem.sentence(5),:job_id => job_id )
  questions = filter.job.questions
  questions.each do |q|
    answer = q.answers.where(:filter_id => filter.id).first
    if !answer
      answer = Answer.new
    end

    if q.has_choices
      random = rand(0..1)
      if random == 0
        choice = q.choices.first
      else
        choice = q.choices.last
      end
      answer.set_values(q.id,nil,choice.id,nil,filter.id)
      answer.save
    end
  end
end

def make_companies
  puts 'Creating companies, admins, recruiters and jobs...'
  5.times do |n|
    Utils.print_and_flush('.')
    company = Company.create!(:name => Faker::Company.name,
                    :about => Faker::Lorem.sentence(60),
                    :phone => Faker::PhoneNumber.phone_number,
                    :country => 'KE',
                    :city => Faker::Address.city,
                    :website => "http://www.test#{n}.com",
                    :package => Package::PREMIUM)
    Token.create!(:company => company,:expiry => Date.today + 60)
    make_user(Role.admin,company.id,"admin@test#{n}.com")
    3.times do |i|
      make_user(Role.recruiter,company.id,"recruiter#{i}@test#{n}.com")
    end
  end
end

def make_applicants
  puts '\n Creating applicants... \n'

  checkpoint = 10
  200.times do |n|
    progress = ((n/720)*100).to_i
    if progress>=checkpoint
      checkpoint = checkpoint+10
      puts "#{progress}%"
    end
    Utils.print_and_flush('.')
    make_user(Role.applicant,nil,"applicant#{n}@me.com")
  end
end

def make_user(role,company_id,email)
  user = User.create!(:first_name => Faker::Name.first_name,
               :last_name => Faker::Name.last_name,
               :email => email,
               :country => 'KE',
               :city => Faker::Address.city,
               :password => '12345',
               :password_confirmation => '12345',
               :role => role,
               :company_id => (role == Role.applicant)? nil : company_id,
                :activated => true,
                :expiry => Date.today + 3)
  if user && role == Role.admin
    job_count = rand(9..12)
    job_count.times do
      make_job(company_id,user.id,user.company.procedures.first.id)
    end
  elsif user && role == Role.applicant
    applications = rand(9..12)
    applications.times do
      max = Job.all.count
      job_id = 0
      loops = 0
      begin
        job_id = rand(1..max)
        loops =loops+1
      end while !Job.exists?(:id => job_id) || Application.exists?(:job_id => job_id,:user_id => user.id)
      job = Job.where(:id => job_id).first
      make_application(job_id,user.id,job.procedure.stages.first.id)
    end
  end
end

def make_application(job_id,user_id,stage_id)
  application = Application.create!(:cover_letter => Faker::Lorem.sentence(150),
                      :job_id => job_id,
                      :user_id => user_id,
                      :status => Application.status_complete,
                      :stage_id => stage_id,
                      :dropped => false)
  make_answers(application.id)
end