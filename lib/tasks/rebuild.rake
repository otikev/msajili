#rake db:rebuild

namespace :db do
  desc 'Rebuild the database (using migrations rather than the schema)'
  task :rebuild do |t, args|
    Rake::Task['db:drop'].invoke
    Rake::Task['db:create'].invoke
    Rake::Task['db:migrate'].invoke
    Rake::Task['db:seed'].invoke
  end
end