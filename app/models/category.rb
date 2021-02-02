# == Schema Information
#
# Table name: categories
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#


class Category < SyncBase
  self.table_name = 'categories'
  RECORD_TYPE = Msajili::Constants::RECORD_CATEGORY

  require 'utils'
  has_many :jobs, inverse_of: :category

  def category_name
    "#{name}"
  end

  def self.get_json(category_id)
    category = Category.where(:id => category_id).first
    if category
      return category.as_json(except: [:created_at, :updated_at])
    end
    nil
  end

end
