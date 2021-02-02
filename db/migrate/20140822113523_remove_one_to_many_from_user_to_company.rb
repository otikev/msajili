class RemoveOneToManyFromUserToCompany < ActiveRecord::Migration
  def change
    remove_column :companies, :user_id
    admins = User.where(:role_id => Role.admin)
    admins.each do |a|
      a.company_id = 1
      a.save
    end
  end
end
