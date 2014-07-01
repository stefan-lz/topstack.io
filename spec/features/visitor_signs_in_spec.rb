require 'spec_helper'

feature 'Visitor signs in', :vcr do
  scenario 'by clicking the sign in link from the nav bar' do
    visit '/'
    click_link 'Sign in'

    fill_in 'Name', :with => 'user'
    fill_in 'Email', :with => 'user@example.com'

    click_button 'Sign In'
    expect(page).to have_content 'Signed in'
  end
end

