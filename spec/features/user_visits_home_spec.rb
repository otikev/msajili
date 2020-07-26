require 'rails_helper'

feature 'Home page' do
  scenario 'User visits homepage' do
    visit '/'
    expect(page).to have_text('Efficient and easy to use recruitment platform')
  end
end