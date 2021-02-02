class AddTokenToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :identifier, :string, :unique => true

    Company.reset_column_information
    Company.order(:id => :asc).each do |c|
      identifier=''
      begin
        identifier = Digest::SHA1.hexdigest(Utils.random_string(10))
      end while Company.exists?(:identifier => identifier)
      c.update_attribute(:identifier, identifier)
    end
  end
end
