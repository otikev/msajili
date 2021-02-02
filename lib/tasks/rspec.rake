#rake test:all

namespace :test do
  desc "Run tests using Rspec"
  task :all do |t, args|
    sh "bundle exec rspec -f html -o ./tmp/spec_results.html"
    sh "launchy './tmp/spec_results.html'"
  end
  task :controllers do |t, args|
    sh "bundle exec rspec spec/controllers -f html -o ./tmp/spec_results.html"
    sh "launchy './tmp/spec_results.html'"
  end
  task :models do |t, args|
    sh "bundle exec rspec spec/models -f html -o ./tmp/spec_results.html"
    sh "launchy './tmp/spec_results.html'"
  end
end