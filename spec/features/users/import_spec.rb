require 'rails_helper'

RSpec.feature 'User import', type: :feature, js: true do
  scenario 'User uploads csv file' do
    visit root_path
    attach_file('user[file]', 'users.csv')

    click_button 'Upload CSV'
    expect(page).to have_text('Muhammad was successfully saved.')
    expect(page).to have_text('Change 1 of Maria Turing password')
    expect(page).to have_text('Change 4 of Isabella password')
    expect(page).to have_text('Change 5 of Axel password')
  end
end
