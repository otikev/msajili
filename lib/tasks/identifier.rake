
namespace :generate do
  task :identifier => :environment do
    companies = Company.order(:id => :desc).load
    companies.each do |c|
      i = 0
      name = c.name
      name.gsub(/[^0-9a-z ]/i, '') #remove all non-alphanumeric characters but keep the spaces
      name.gsub! ' ','-' # replace all spaces with a dash
      begin
        if i == 0
          c.identifier = "#{name}"
        else
          c.identifier = "#{i}-#{name}"
        end
        i = i + 1
      end while Company.exists?(:identifier => c.identifier)
      c.save!
    end
  end
end