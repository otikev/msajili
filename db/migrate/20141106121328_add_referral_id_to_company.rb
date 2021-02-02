class AddReferralIdToCompany < ActiveRecord::Migration
  def change
    add_column :companies, :referral_id, :string
  end
end
