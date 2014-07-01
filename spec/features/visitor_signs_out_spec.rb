require 'spec_helper'
require_relative 'helpers/session_helper'

feature 'Visitor signs out', :vcr do
  include Features::SessionHelper

  scenario 'after signing in' do
    sign_in_with 'john doe', 'john.dow@gmail.com'

    click_link 'Sign out'
    expect(page).to have_content 'Signed out'
  end
end
