class AddReferralIdToCompany < ActiveRecord::Migration[6.0]
  def change
    add_column :companies, :referral_id, :string
  end
end
